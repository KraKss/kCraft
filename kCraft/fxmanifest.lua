fx_version "cerulean"
game "gta5"

lua54 'yes'

escrow_ignore {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/UIButton.lua",
    "src/menu/items/UICheckBox.lua",
    "src/menu/items/UILine.lua",
    "src/menu/items/UISeparator.lua",
    "src/menu/items/UISlider.lua",    
    "src/menu/items/UISliderHeritage.lua",
    "src/menu/items/UISliderProgress.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "shared/*.lua",
    "init/cl_init.lua",
    "init/sv_init.lua",
    "server/function.lua",
    "sql.sql"
}

shared_scripts {                  
    "shared/*.lua",    
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    "init/cl_init.lua",
    "client/*.lua",
}

server_scripts {
    "init/sv_init.lua",
    "server/*.lua",
}