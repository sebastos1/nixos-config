local waywall = require("waywall")
local helpers = require("waywall.helpers")

local Scene = require("waywork.scene")
local Modes = require("waywork.modes")
local Keys = require("waywork.keys")
local Processes = require("waywork.processes")

local scene = Scene.SceneManager.new(waywall)
local ModeManager = Modes.ModeManager.new(waywall)

local resolution = { w = 1920, h = 1080 }

local thin_w = resolution.h * 0.28
local tall_w = 340
local tall_h = 16384

local e_src_scale = thin_w < 640 and 1 or 2
local e_scale = 10
local e_w = 49 * e_src_scale
local e_h = 9 * e_src_scale

local eye_w = (resolution.w - tall_w) / 2
local eye_h = (resolution.h * eye_w) / resolution.w
local eye_dst = { x = 0, y = (resolution.h - eye_h) / 2, w = eye_w, h = eye_h }
local mc_eye_w = 60
local mc_eye_h = 580
local mc_eye_x = (tall_w - mc_eye_w) / 2
local mc_eye_y = (tall_h - mc_eye_h) / 2

-- https://arjuncgore.github.io/waywall-boat-eye-calc/
-- https://github.com/Esensats/mcsr-calcsens
local normal_sens = 4.39040021
local tall_sens = 0.29617377

local left_middle = (resolution.w - thin_w) / 4
scene:register("e_counter", {
    kind = "mirror",
    options = {
        src = { x = 1 * e_src_scale, y = 37 * e_src_scale, w = e_w, h = e_h },
        dst = { x = left_middle - (e_w * e_scale / 2), y = resolution.h / 10.8, w = e_w * e_scale, h = e_h * e_scale },
        depth = 0,
    },
    groups = { "thin" },
})

scene:register("eye_measure", {
    kind = "mirror",
    options = {
        src = { x = mc_eye_x, y = mc_eye_y, w = mc_eye_w, h = mc_eye_h },
        dst = eye_dst,
        depth = 0,
    },
    groups = { "tall" },
})

scene:register("eye_overlay", {
    kind = "image",
    path = files.eye_overlay,
    options = { dst = eye_dst, depth = 1 },
    groups = { "tall" },
})

scene:register("typing_text", {
    kind = "text",
    text = "typing mode!",
    groups = { "typing" },
    options = {
        x = 200,
        y = 200,
        size = 64,
    },
})

-- not when holding f3 or in typing mode
local typing_mode = false
function f3_guard()
    return not waywall.get_key("F3") and not typing_mode
end

ModeManager:define("thin", {
    width = thin_w,
    height = resolution.h,
    on_enter = function()
        scene:enable_group("thin", true)
    end,
    on_exit = function()
        scene:enable_group("thin", false)
    end,
    toggle_guard = f3_guard,
})

ModeManager:define("wide", {
    width = resolution.w,
    height = resolution.h / 3.6,
    on_enter = function()
        scene:enable_group("wide", true)
    end,
    on_exit = function()
        scene:enable_group("wide", false)
    end,
    toggle_guard = f3_guard,
})

ModeManager:define("tall", {
    width = tall_w,
    height = tall_h,
    on_enter = function()
        scene:enable_group("tall", true)
        waywall.set_sensitivity(tall_sens)
        show_ninjabrain(true)
    end,
    on_exit = function()
        scene:enable_group("tall", false)
        waywall.set_sensitivity(0)
    end,
    toggle_guard = f3_guard,
})

ModeManager:define("typing", {
    width = resolution.w,
    height = resolution.h,
    on_enter = function()
        scene:enable_group("typing", true)
        typing_mode = true
    end,
    on_exit = function()
        scene:enable_group("typing", false)
        typing_mode = false
    end,
})

local ensure_ninjabrain = Processes.ensure_application(waywall, programs.ninjabrain_bot)("ninjabrain.*\\.jar")
waywall.listen("load", ensure_ninjabrain)

function show_ninjabrain(show)
    if show then ensure_ninjabrain() end
    waywall.show_floating(show)
end

local config = {
    input = {
        layout = "no",
        repeat_rate = 40,
        repeat_delay = 300,

        sensitivity = normal_sens,
        confine_pointer = true,

        remaps = {
            ["MB5"] = "F3",
            ["Z"] = "0",
        },
    },
    theme = {
        background = "#303030ff",
        -- https://github.com/Smithay/smithay/issues/1894
        ninb_anchor = "topright",
    },
    window = {
        fullscreen_width = resolution.w,
        fullscreen_height = resolution.h,
    },
    actions = Keys.actions({
        ["*-V"] = function()
            return ModeManager:toggle("thin")
        end,
        ["*-G"] = function()
            return ModeManager:toggle("wide")
        end,
        ["*-B"] = function()
            return ModeManager:toggle("tall")
        end,
        ["*-N"] = function()
            helpers.toggle_floating()
            return false -- don't consume key
        end,
        ["ctrl-O"] = function()
            return ModeManager:toggle("typing")
        end,
        ["*-alt_l"] = function()
            return ModeManager:_transition_to(nil)
        end,
    }),
}

return config
