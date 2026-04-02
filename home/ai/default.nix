{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mcp-nixos
    uv
  ];

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      model = "claude-sonnet-4-6";
      permissions = {
        allow = [
          "Read(/etc/nixos/**)"
          "Edit(/etc/nixos/**)"
          "Read(~/src/**)"
          "Edit(~/src/**)"
          "Bash(nix:*)"
          "Bash(git:*)"
        ];
        deny = [
          "Bash(rm:*)"
          "Bash(sudo:*)"
          # "Bash(**)"
          # "WebFetch(**)"
        ];
        additionalDirectories = [
          "/etc/nixos/"
        ];
        # defaultMode = "acceptEdits";
      };
      env = {
        ENABLE_CLAUDEAI_MCP_SERVERS = false;
      };
    };

    # CLAUDE.md
    memory.text = ''
      <do_not_act_before_instructions>
      Do not modify files unless clearly instructed. When intent is ambiguous, default to providing information and recommendations rather than taking action.
      </do_not_act_before_instructions>

      <avoid_overengineering>
      Less code is better - simpler is almost always better.
      Only make changes that are directly requested or clearly necessary.
      - Scope: Don't add features, refactor, or "improve" beyond what was asked.
      - Documentation: Don't add docstrings or comments to code you didn't change.
      - Defensive coding: Don't add error handling for scenarios that can't happen. Only validate at system boundaries.
      - Abstractions: Don't create helpers for one-time operations. Minimum complexity for the current task.
      </avoid_overengineering>

      <investigate_before_answering>
      Never speculate about code you have not opened. Read relevant files BEFORE answering questions about the codebase.
      </investigate_before_answering>

      <use_parallel_tool_calls>
      If you intend to call multiple tools and there are no dependencies between the tool calls, make all of the independent tool calls in parallel. Prioritize calling tools simultaneously whenever the actions can be done in parallel rather than sequentially. For example, when reading 3 files, run 3 tool calls in parallel to read all 3 files into context at the same time. Maximize use of parallel tool calls where possible to increase speed and efficiency. However, if some tool calls depend on previous calls to inform dependent values like the parameters, do NOT call these tools in parallel and instead call them sequentially. Never use placeholders or guess missing parameters in tool calls.
      </use_parallel_tool_calls>
    '';

    # agents = {
    #   search = ''
    #     ---
    #     name: search
    #     description: Use for web searches, looking up documentation, finding information. Any task that is primarily retrieval rather than reasoning.
    #     model: haiku
    #     tools: mcp__brave-search__brave_web_search, mcp__nixos__nix
    #     ---

    #     You are a fast search assistant. Search for the requested information and return concise, relevant results. Do not reason or analyze beyond what is needed to answer the query.
    #   '';
    # };
  };

  programs.mcp = {
    enable = true;
    servers = {
      nixos = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
      };
      # brave-search = {
      #   command = "npx";
      #   args = [
      #     "-y"
      #     "@modelcontextprotocol/server-brave-search"
      #   ];
      #   env.BRAVE_API_KEY = "your-key";
      # };
    };
  };
}
