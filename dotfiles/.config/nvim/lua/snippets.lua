-- Examples
-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

require("luasnip.session.snippet_collection").clear_snippets()

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local rep = extras.rep


ls.add_snippets(
  "ruby", {
    s("putsi", { t('puts "####### '), i(1), t(' #{'), rep(1), t('}"') }),
    s("frozen", { t('# frozen_string_literal: true') }),
  }
)

ls.add_snippets(
  "javascript", {
    s("consl", { t('console.log("'), i(1), t('")') }),
  }
)
