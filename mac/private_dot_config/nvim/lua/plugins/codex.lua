return {
  {
    "nwiizo/codex.nvim",
    commit = "4b037a861139cc7f277df80dcabc22fa30601fee",
    pin = true,
    cmd = {
      "Codex", "CodexAsk", "CodexAskVisual", "CodexFollowUp",
      "CodexResume", "CodexContinue", "CodexClose", "CodexStop",
      "CodexDiff", "CodexHealth", "CodexStatus",
    },
    keys = {
      { "<leader>ac", "<cmd>Codex<cr>", desc = "Toggle Codex" },
      { "<leader>aa", "<cmd>CodexAsk<cr>", desc = "Ask Codex about this file" },
      { "<leader>aa", ":<C-u>CodexAskVisual<cr>", mode = "x", desc = "Ask Codex about selection" },
      { "<leader>af", "<cmd>CodexFollowUp<cr>", desc = "Follow up with Codex" },
      { "<leader>ad", "<cmd>CodexDiff<cr>", desc = "Show Codex diff" },
    },
    opts = {
      backend = "app_server",
      selection = { enabled = false },
      terminal = { split_side = "right", split_width_percentage = 0.35 },
    },
  },
}
