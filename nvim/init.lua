---------- INITIALIZE CONFIG ----------

if require('seblj.first_load')() then
    return
end

require('seblj.globals')
require('seblj.utils.keymap')
require('seblj.options')
require('seblj.keymaps')
require('seblj.plugins')
