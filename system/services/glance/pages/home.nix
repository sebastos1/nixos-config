let
  location = "Oslo, Norway";
in
{
  name = "Home";
  columns = [
    # left
    {
      size = "small";
      widgets = [
        {
          type = "clock";
          hour-format = "24h";
        }
        {
          type = "calendar";
          first-day-of-week = "monday";
        }
        {
          type = "custom-api";
          title = "Time Remaining";
          body-type = "string";
          skip-json-validation = true;
          cache = "1m";
          template = ''
            {{ $t := now }}

            {{ $secsElapsed := add (mul $t.Hour 3600) (mul $t.Minute 60) | add $t.Second }}
            {{ $secsLeft    := sub 86400 $secsElapsed }}
            {{ $hrsLeft     := div $secsLeft 3600 }}
            {{ $dayPct      := div (mul $secsElapsed 100.0) 86400 }}
            {{ $dayRemain   := sub 100.0 $dayPct }}

            {{ $doy          := $t.YearDay }}
            {{ $daysLeftYear := sub 365 $doy }}
            {{ $yearPct      := div (mul $doy 100.0) 365 }}
            {{ $yearRemain   := sub 100.0 $yearPct }}

            <div style="display:flex;flex-direction:column;gap:10px;">
              <div>
                <div style="display:flex;justify-content:space-between;margin-bottom:4px;">
                  <span class="color-highlight">{{ $hrsLeft }}h left of day</span>
                  <span class="color-subdue size-h5">{{ printf "%.0f" $dayPct }}%</span>
                </div>
                <div style="position:relative;width:100%;height:8px;border:1px solid gray;border-radius:10px;overflow:hidden;background:linear-gradient(90deg,#4a90d9 0%,#5cb85c 30%,#5cb85c 70%,#4a90d9 100%);">
                  <div style="position:absolute;top:0;right:0;height:100%;width:{{ $dayRemain }}%;background:#23262F;"></div>
                </div>
              </div>

              <div>
                <div style="display:flex;justify-content:space-between;margin-bottom:4px;">
                  <span class="color-highlight">{{ $daysLeftYear }}d left of year</span>
                  <span class="color-subdue size-h5">{{ printf "%.0f" $yearPct }}%</span>
                </div>
                <div style="position:relative;width:100%;height:8px;border:1px solid gray;border-radius:10px;overflow:hidden;background:linear-gradient(90deg,#4a90d9 0%,#5cb85c 25%,#e05c5c 50%,#f0c040 75%,#4a90d9 100%);">
                  <div style="position:absolute;top:0;right:0;height:100%;width:{{ $yearRemain }}%;background:#23262F;"></div>
                </div>
              </div>
            </div>
          '';
        }
        {
          type = "to-do";
          id = "main";
          title = "Today";
        }
        {
          type = "custom-api";
          height = "200px";
          title = "Duck of the Moment";
          cache = "10m";
          url = "https://random-d.uk/api/v2/random";
          template = ''
            <img src="{{ .JSON.String "url" }}" style="width:100%;height:auto;border-radius:4px;" />
          '';
        }
      ];
    }

    # middle
    {
      size = "full";
      widgets = [
        # todo make module ig
        {
          type = "monitor";
          title = "Services";
          cache = "1m";
          sites = [
            {
              title = "You are here";
              url = "http://localhost:8080";
              icon = "si:glance";
            }
            {
              title = "Forgejo";
              url = "http://10.0.0.3";
              icon = "si:forgejo";
            }
            {
              title = "Matrix";
              url = "http://10.0.0.4";
              icon = "si:matrix";
            }

            # Uncomment and edit as needed:
            # { title = "Jellyfin";  url = "http://localhost:8096"; icon = "sh:jellyfin"; }
            # { title = "Immich";    url = "http://localhost:2283"; icon = "sh:immich"; }
            # { title = "Gitea";     url = "http://localhost:3000"; icon = "si:gitea"; }
            # { title = "AdGuard";   url = "http://localhost:3000"; icon = "si:adguard"; }
            # { title = "Vaultwarden"; url = "http://localhost:8880"; icon = "si:vaultwarden"; }
            # { title = "qBittorrent"; url = "http://localhost:8080"; icon = "si:qbittorrent"; }
          ];
        }
      ];
    }

    # right side
    {
      size = "small";
      widgets = [
        {
          type = "weather";
          hour-format = "24h";
          inherit location;
        }

        # this is terrible
        {
          type = "custom-api";
          title = "Forecast";
          body-type = "string";
          cache = "1h";
          options = {
            inherit location;
          };
          template = ''
            {{ $weekend_color  := .Options.StringOr "weekend_color"  "var(--color-separator)" }}
            {{ $overlay_color  := .Options.StringOr "overlay_color"  "hsl(var(--bghs), var(--bgl), 50%)" }}

            {{ $color_clear         := "#FFA500" }}
            {{ $color_partly        := "#EBE387" }}
            {{ $color_cloud         := "#A9A9A9" }}
            {{ $color_smog          := "#D3D3D3" }}
            {{ $color_drizzle       := "#5F9EA0" }}
            {{ $color_rain          := "#4682B4" }}
            {{ $color_freezing_rain := "#B0E0E6" }}
            {{ $color_snow          := "#FFFFFF" }}
            {{ $color_thunderstorm  := "#696969" }}
            {{ $color_other         := "#FFFFFF" }}

            {{ $color_red  := "#e05c5c" }}
            {{ $color_blue := "#46F0F0" }}

            {{ $temp_red  := 25.0 }}
            {{ $temp_blue := -5.0 }}

            {{ $loc  := replaceAll " " "%20" (.Options.StringOr "location" "") }}
            {{ $req1 := newRequest (printf "https://geocoding-api.open-meteo.com/v1/search?name=%s&count=1&language=en&format=json" $loc) | getResponse }}
            {{ $lat  := $req1.JSON.String "results.0.latitude" }}
            {{ $lon  := $req1.JSON.String "results.0.longitude" }}
            {{ $req2 := newRequest (printf "https://api.open-meteo.com/v1/forecast?latitude=%s&longitude=%s&temperature_unit=celsius&daily=temperature_2m_max,temperature_2m_min,weathercode" $lat $lon) | getResponse }}

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
            <div style="display:flex;justify-content:center;align-items:center;flex-direction:column;">

              {{ $dates := $req2.JSON.Array "daily.time" }}

              {{/* Day of week row */}}
              <div style="position:relative;width:100%;height:25px;">
                {{ range $i, $date := $dates }}
                  {{ $dow := ($date.String "" | parseTime "DateOnly").Format "Monday" | trimSuffix "day" | trimSuffix "on" | trimSuffix "es" | trimSuffix "edn" | trimSuffix "urs" | trimSuffix "ri" | trimSuffix "tur" | trimSuffix "n" }}
                  {{ $bg := "" }}
                  {{ if eq $dow "Sa" "Su" }}{{ $bg = $weekend_color }}{{ end }}
                  <div style="text-align:center;width:10%;height:25px;line-height:25px;margin:0 10% 0 3%;left:{{ mul $i 14 }}%;position:absolute;background-color:{{ $bg | safeCSS }};">
                    <p class="size-h4 color-paragraph">{{ $dow }}</p>
                  </div>
                {{ end }}
              </div>

              {{/* Day of month row */}}
              <div style="position:relative;width:100%;height:25px;">
                {{ range $i, $date := $dates }}
                  {{ $day := replaceMatches "[0-9]+-[0-9]+-" "" (.String "") }}
                  <div style="text-align:center;width:10%;height:25px;line-height:25px;margin:0 10% 0 3%;left:{{ mul $i 14 }}%;position:absolute;">
                    <p class="size-h4 color-paragraph">{{ $day }}</p>
                  </div>
                {{ end }}
              </div>

              {{/* Weather icon row */}}
              {{ $codes := $req2.JSON.Array "daily.weathercode" }}
              <div style="position:relative;width:100%;height:30px;">
                {{ range $i, $c := $codes }}
                  {{ $code  := .Int "" }}
                  {{ $wicon := "fa-solid fa-question" }}
                  {{ $wcolor := $color_other }}
                  {{ $wtype  := "Other" }}
                  {{ if eq $code 0 }}
                    {{ $wtype = "Clear" }}{{ $wicon = "fas fa-sun" }}{{ $wcolor = $color_clear }}
                  {{ else if eq $code 1 2 }}
                    {{ $wtype = "Part Clear" }}{{ $wicon = "fas fa-cloud-sun" }}{{ $wcolor = $color_partly }}
                  {{ else if eq $code 3 }}
                    {{ $wtype = "Cloudy" }}{{ $wicon = "fas fa-cloud" }}{{ $wcolor = $color_cloud }}
                  {{ else if eq $code 45 48 }}
                    {{ $wtype = "Fog" }}{{ $wicon = "fas fa-smog" }}{{ $wcolor = $color_smog }}
                  {{ else if eq $code 51 53 55 56 57 }}
                    {{ $wtype = "Drizzle" }}{{ $wicon = "fas fa-cloud-rain" }}{{ $wcolor = $color_drizzle }}
                  {{ else if eq $code 61 63 65 80 81 82 }}
                    {{ $wtype = "Rain" }}{{ $wicon = "fas fa-cloud-showers-heavy" }}{{ $wcolor = $color_rain }}
                  {{ else if eq $code 66 67 }}
                    {{ $wtype = "Freezing Rain" }}{{ $wicon = "fas fa-snowflake" }}{{ $wcolor = $color_freezing_rain }}
                  {{ else if eq $code 71 73 75 77 85 86 }}
                    {{ $wtype = "Snow" }}{{ $wicon = "fas fa-snowman" }}{{ $wcolor = $color_snow }}
                  {{ else if eq $code 95 96 99 }}
                    {{ $wtype = "Thunderstorm" }}{{ $wicon = "fas fa-bolt" }}{{ $wcolor = $color_thunderstorm }}
                  {{ end }}
                  <div style="text-align:center;width:10%;height:25px;line-height:25px;margin:0 10% 0 3%;left:{{ mul $i 14 }}%;position:absolute;">
                    <i class="{{ $wicon }}" style="font-size:20px;color:{{ $wcolor | safeCSS }};" title="{{ $wtype }}"></i>
                  </div>
                {{ end }}
              </div>

            </div>

            {{/* Temperature bar chart */}}
            {{ $maxTemps := $req2.JSON.Array "daily.temperature_2m_max" }}
            {{ $minTemps := $req2.JSON.Array "daily.temperature_2m_min" }}

            {{ $max_max := 0 }}
            {{ range $maxTemps }}{{ if gt (.Int "") $max_max }}{{ $max_max = .Int "" }}{{ end }}{{ end }}
            {{ $min_min := 999 }}
            {{ range $minTemps }}{{ if lt (.Int "") $min_min }}{{ $min_min = .Int "" }}{{ end }}{{ end }}
            {{ $max_max = add $max_max 1 }}
            {{ $min_min = sub $min_min 1 }}

            <div style="display:flex;justify-content:flex-start;align-items:center;">
              <div style="position:relative;width:100%;height:75px;">
                {{ $temp_range := sub $max_max $min_min }}
                {{ range $i, $hi := $maxTemps }}
                  {{ $lo     := (index $minTemps $i).Float "" }}
                  {{ $hi      = $hi.Float "" }}
                  {{ $hiPct  := sub 1 (div (sub $max_max $hi) $temp_range) }}
                  {{ $loPct  := div (sub $lo $min_min) $temp_range }}
                  {{ $thisTR := sub $hi $lo }}

                  {{ $red_pos := mul 100 (div (sub $hi $temp_red)  $thisTR) | toInt }}
                  {{ $blu_pos := mul 100 (div (sub $hi $temp_blue) $thisTR) | toInt }}
                  {{ $grad    := printf "%s %d%%, %s %d%%" $color_red $red_pos $color_blue $blu_pos }}

                  {{ $top_pos := -2 }}
                  {{ $bot_pos := -2 }}
                  {{ $thresh  := 0.20 }}
                  {{ if lt (div $thisTR $temp_range) $thresh }}
                    {{ $top_pos = -17 }}{{ $bot_pos = -19 }}
                  {{ else if and (lt (div $thisTR $temp_range) (mul $thresh 2)) (lt (sub 1 $hiPct) $loPct) }}
                    {{ $bot_pos = -19 }}
                  {{ else if and (lt (div $thisTR $temp_range) (mul $thresh 2)) (gt (sub 1 $hiPct) $loPct) }}
                    {{ $top_pos = -17 }}
                  {{ end }}

                  <div style="left:{{ mul $i 14 | add 3 }}%;bottom:{{ mul $loPct 100 | toInt }}%;height:{{ mul (sub $hiPct $loPct) 100 | toInt }}%;position:absolute;background:linear-gradient({{ $grad | safeCSS }});width:10%;text-align:center;border-radius:10px;">
                    <div style="position:absolute;top:0;left:0;width:100%;height:100%;background-color:{{ $overlay_color | safeCSS }};z-index:1;border-radius:10px;">
                      <p style="color:#F0F0F0;position:absolute;top:{{ $top_pos }}px;left:0;right:0;">{{ $hi | toInt }}</p>
                      <p style="color:#F0F0F0;position:absolute;bottom:{{ $bot_pos }}px;left:0;right:0;">{{ $lo | toInt }}</p>
                    </div>
                  </div>
                {{ end }}
              </div>
            </div>
          '';
        }

        # Air quality
        # https://github.com/glanceapp/community-widgets/blob/main/widgets/air-quality/README.md
        # {
        #   type = "custom-api";
        #   title = "Air Quality";
        #   cache = "10m";
        #   url = "https://api.waqi.info/feed/geo:59.9139;10.7522/?token=${WAQI_TOKEN}";
        #   template = ''
        #     {{ $aqi    := printf "%03s" (.JSON.String "data.aqi") }}
        #     {{ $aqiraw := .JSON.String "data.aqi" }}
        #     {{ $hum    := .JSON.String "data.iaqi.h.v" }}
        #     {{ $o3     := .JSON.String "data.iaqi.o3.v" }}
        #     {{ $pm25   := .JSON.String "data.iaqi.pm25.v" }}
        #     {{ $pres   := .JSON.String "data.iaqi.p.v" }}
        #     <div>
        #       {{ if le $aqi "050" }}<div class="color-positive size-h5">Good</div>
        #       {{ else if le $aqi "100" }}<div class="color-primary size-h5">Moderate</div>
        #       {{ else }}<div class="color-negative size-h5">Bad</div>{{ end }}
        #     </div>
        #     <div class="color-highlight size-h2">AQI: {{ $aqiraw }}</div>
        #     <div style="border-bottom:1px solid;margin-block:10px;"></div>
        #     <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
        #       <div><div class="size-h3 color-highlight">{{ $hum }}%</div><div class="size-h6">HUMIDITY</div></div>
        #       <div><div class="size-h3 color-highlight">{{ $o3 }} μg/m³</div><div class="size-h6">OZONE</div></div>
        #       <div><div class="size-h3 color-highlight">{{ $pm25 }} μg/m³</div><div class="size-h6">PM2.5</div></div>
        #       <div><div class="size-h3 color-highlight">{{ $pres }} hPa</div><div class="size-h6">PRESSURE</div></div>
        #     </div>
        #   '';
        # }
        {
          type = "custom-api";
          title = "Daily Chess Puzzle";
          cache = "6h";
          url = "https://api.chess.com/pub/puzzle";
          template = ''
            <div style="text-align: center;">
              <h3 style="font-size: 1.5rem; margin: 0 0 8px 0;">
                <a href="{{ .JSON.String "url" }}" target="_blank" style="text-decoration: underline;">
                  {{ .JSON.String "title" }}
                </a>
              </h3>
              <img src="{{ .JSON.String "image" }}" alt="Daily Chess Puzzle" style="max-width:100%; height:auto; border-radius: 3px;">
            </div>
          '';
        }
      ];
    }
  ];
}

# # Trending GitHub repos
# # https://github.com/glanceapp/community-widgets/blob/main/widgets/trending-github-repositories/README.md
# {
#   type = "custom-api";
#   title = "Trending Repositories";
#   cache = "24h";
#   url = "https://api.ossinsight.io/v1/trends/repos/?period=past_28_days&language=All";
#   template = ''
#     <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
#       {{ range .JSON.Array "data.rows" }}
#         <li>
#           <a class="color-primary-if-not-visited" href="https://github.com/{{ .String "repo_name" }}">{{ .String "repo_name" }}</a>
#           <ul class="list-horizontal-text">
#             <li class="color-highlight">{{ .String "primary_language" }}</li>
#             <li>⭐ {{ .Int "stars" }}</li>
#             <li>🍴 {{ .Int "forks" }}</li>
#           </ul>
#         </li>
#       {{ end }}
#     </ul>
#   '';
# }

# # Epic Games free games
# # https://github.com/glanceapp/community-widgets/blob/main/widgets/epic-free-widget/README.md
# {
#   type = "custom-api";
#   title = "Epic Free Games";
#   cache = "1h";
#   url = "https://store-site-backend-static.ak.epicgames.com/freeGamesPromotions?locale=en&country=NO&allowCountries=NO";
#   template = ''
#     {{ if eq .Response.StatusCode 200 }}
#       <div class="horizontal-cards-2">
#         {{ range .JSON.Array "data.Catalog.searchStore.elements" }}
#           {{ $price    := .String "price.totalPrice.discountPrice" }}
#           {{ $hasPromo := gt (len (.Array "promotions.promotionalOffers")) 0 }}
#           {{ if and $hasPromo (eq $price "0") }}
#             {{ $slug := .String "productSlug" }}
#             {{ if gt (len (.Array "offerMappings")) 0 }}{{ $slug = .String "offerMappings.0.pageSlug" }}{{ end }}
#             <a href="https://store.epicgames.com/en-US/p/{{ $slug }}" target="_blank" class="card">
#               {{ $title := .String "title" }}
#               {{ range .Array "keyImages" }}
#                 {{ if eq (.String "type") "OfferImageWide" }}
#                   <img src="{{ .String "url" }}" alt="{{ $title }}" style="width:100%;height:150px;object-fit:cover;border-radius:var(--border-radius);">
#                 {{ end }}
#               {{ end }}
#               <div class="card-content">
#                 <span class="size-base color-primary">{{ $title }}</span><br>
#                 <span class="size-h5 color-subdue">
#                   {{ $promos := .Array "promotions.promotionalOffers" }}
#                   {{ if gt (len $promos) 0 }}
#                     {{ $offers := (index $promos 0).Array "promotionalOffers" }}
#                     {{ if gt (len $offers) 0 }}Free until {{ slice ((index $offers 0).String "endDate") 0 10 }}{{ end }}
#                   {{ end }}
#                 </span>
#               </div>
#             </a>
#           {{ end }}
#         {{ end }}
#       </div>
#     {{ else }}
#       <p class="color-negative">Error fetching Epic Games data.</p>
#     {{ end }}
#   '';
# }

# # Steam specials (cc=no for NOK, cc=us for USD, cc=eu for EUR)
# # https://github.com/glanceapp/community-widgets/blob/main/widgets/steam-specials/README.md
# {
#   type = "custom-api";
#   title = "Steam Specials";
#   cache = "12h";
#   url = "https://store.steampowered.com/api/featuredcategories?cc=no";
#   template = ''
#     <ul class="list list-gap-10 collapsible-container" data-collapse-after="5">
#       {{ range .JSON.Array "specials.items" }}
#         {{ $header    := .String "header_image" }}
#         {{ $urlPrefix := "https://store.steampowered.com/sub/" }}
#         {{ if findMatch "/steam/apps/" $header }}{{ $urlPrefix = "https://store.steampowered.com/app/" }}{{ end }}
#         <li>
#           <a class="size-h4 color-highlight block text-truncate" href="{{ $urlPrefix }}{{ .Int "id" }}/">{{ .String "name" }}</a>
#           <ul class="list-horizontal-text">
#             <li>kr {{ .Int "final_price" | toFloat | mul 0.01 | printf "%.2f" }}</li>
#             {{ $disc := .Int "discount_percent" }}
#             <li{{ if ge $disc 40 }} class="color-positive"{{ end }}>{{ $disc }}% off</li>
#           </ul>
#         </li>
#       {{ end }}
#     </ul>
#   '';
# }
