---@brief
---
--- https://projects.eclipse.org/projects/eclipse.jdt.ls
---
--- Language server for Java.
---
--- IMPORTANT: If you want all the features jdtls has to offer, [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
--- is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
--- you can keep reading here.
---
--- For manual installation you can download precompiled binaries from the
--- [official downloads site](http://download.eclipse.org/jdtls/snapshots/?d)
--- and ensure that the `PATH` variable contains the `bin` directory of the extracted archive.
---
--- ```lua
---   -- init.lua
---   vim.lsp.enable('jdtls')
--- ```
---
--- You can also pass extra custom jvm arguments with the JDTLS_JVM_ARGS environment variable as a space separated list of arguments,
--- that will be converted to multiple --jvm-arg=<param> args when passed to the jdtls script. This will allow for example tweaking
--- the jvm arguments or integration with external tools like lombok:
---
--- ```sh
--- export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"
--- ```
---
--- For automatic installation you can use the following unofficial installers/launchers under your own risk:
---   - [jdtls-launcher](https://github.com/eruizc-dev/jdtls-launcher) (Includes lombok support by default)
---     ```lua
---       -- init.lua
---       vim.lsp.config('jdtls', { cmd = { 'jdtls' } })
---     ```

local function get_jdtls_jvm_args()
    local env = os.getenv('JDTLS_JVM_ARGS')
    local args = {}
    for a in string.gmatch((env or ''), '%S+') do
        table.insert(args, string.format('--jvm-arg=%s', a))
    end
    return args
end

local function find_main_classes(project_root)
    local main_classes = {}
    local src_dir = project_root .. '/src'

    -- Recursively scan for Java files using Neovim's vim.fs
    local function scan_directory(dir)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then
            print("Cannot scan directory: " .. dir)
            return
        end

        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end

            local path = dir .. '/' .. name

            if type == 'directory' then
                -- Recursively scan subdirectories
                scan_directory(path)
            elseif type == 'file' and name:match('%.java$') then
                -- Read file content
                local f = io.open(path, 'r')
                if f then
                    local content = f:read('*all')
                    f:close()

                    -- Check if file has main method
                    if content:match('public%s+static%s+void%s+main%s*%(') then
                        local package = content:match('package%s+([%w%.]+)%s*;')
                        local class_name = name:match('(.+)%.java$')

                        if package and class_name then
                            local full_class = package .. '.' .. class_name
                            table.insert(main_classes, full_class)
                        elseif class_name then
                            table.insert(main_classes, class_name)
                        end
                    end
                end
            end
        end
    end

    -- Check if src directory exists
    if vim.fn.isdirectory(src_dir) == 1 then
        print("Scanning: " .. src_dir)
        scan_directory(src_dir)
    else
        print("ERROR: src directory not found at: " .. src_dir)
    end

    if #main_classes > 0 then
        print("Total main classes found: " .. #main_classes .. ", Main classes: " .. vim.inspect(main_classes))
    end

    return main_classes
end

-- Configure JDTLS
vim.lsp.config('jdtls', {
    cmd = function(dispatchers, config)
        local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace'
        local data_dir = workspace_dir

        if config.root_dir then
            data_dir = data_dir .. '/' .. vim.fn.fnamemodify(config.root_dir, ':p:h:t')
        end

        local jvm_args = get_jdtls_jvm_args()
        local cmd = { 'jdtls', '-data', data_dir }

        for _, arg in ipairs(jvm_args) do
            table.insert(cmd, arg)
        end

        return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
        })
    end,

    filetypes = { 'java' },
    root_markers = { 'pom.xml', 'build.gradle', 'mvnw', 'gradlew', '.git' },

    on_attach = function(client, bufnr)
        -- Check if .nvim.lua exists in project root
        local nvim_lua_exists = false
        local pom = vim.fs.find('pom.xml', {
            upward = true,
            path = vim.fn.expand('%:p:h')
        })[1]

        if pom then
            local project_root = vim.fs.dirname(pom)
            local nvim_lua_path = project_root .. '/.nvim.lua'
            nvim_lua_exists = vim.fn.filereadable(nvim_lua_path) == 1
        end

        -- Only set F5 if .nvim.lua doesn't exist (project-specific config takes precedence)
        if not nvim_lua_exists then
            -- F5: Run Java project with Maven
            vim.keymap.set('n', '<F5>', function()
                -- Find pom.xml
                local pom_file = vim.fs.find('pom.xml', {
                    upward = true,
                    path = vim.fn.expand('%:p:h')
                })[1]

                if not pom_file then
                    vim.notify("No pom.xml found!", vim.log.levels.ERROR)
                    return
                end

                print("Found pom.xml: " .. pom_file)
                local project_root = vim.fs.dirname(pom_file)

                -- Find main classes
                local main_classes = find_main_classes(project_root)

                if #main_classes == 0 then
                    vim.notify("No main class found! Check :messages for details", vim.log.levels.ERROR)
                    return
                end

                -- Select main class
                local function run_with_class(main_class)
                    vim.notify("Running: " .. main_class, vim.log.levels.INFO)
                    vim.cmd('wa')

                    local cmd = string.format(
                        'mvn -f "%s" clean compile exec:java -Dexec.mainClass="%s"',
                        pom_file, main_class
                    )

                    print("Executing: " .. cmd)
                    vim.cmd('split | terminal ' .. cmd)
                    vim.cmd('startinsert')
                end

                if #main_classes == 1 then
                    -- Only one main class, run it directly
                    run_with_class(main_classes[1])
                else
                    -- Multiple main classes, let user choose
                    vim.ui.select(main_classes, {
                        prompt = 'Select main class:'
                    }, function(choice)
                        if choice then
                            run_with_class(choice)
                        end
                    end)
                end
            end, {
                buffer = bufnr,
                desc = 'Java: Run (Maven)',
                noremap = true,
                silent = false
            })
        else
            print("Skipping F5 mapping - .nvim.lua exists") -- DEBUG
        end

        -- F9: Debug with DAP (if available)
        local ok, dap = pcall(require, 'dap')
        if ok then
            if not dap.configurations.java then
                dap.configurations.java = {
                    {
                        type = 'java',
                        request = 'launch',
                        name = 'Debug Main Class',
                        mainClass = function()
                            local pom_file = vim.fs.find('pom.xml', {
                                upward = true,
                                path = vim.fn.expand('%:p:h')
                            })[1]

                            if pom_file then
                                local project_root = vim.fs.dirname(pom_file)
                                local main_classes = find_main_classes(project_root)

                                if #main_classes == 1 then
                                    return main_classes[1]
                                elseif #main_classes > 1 then
                                    -- Will show selection dialog
                                    local choice = nil
                                    vim.ui.select(main_classes, {
                                        prompt = 'Select main class:'
                                    }, function(selected)
                                        choice = selected
                                    end)
                                    return choice or main_classes[1]
                                end
                            end

                            return vim.fn.input('Main class > ')
                        end,
                        projectName = function()
                            return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
                        end,
                    },
                }
            end

            vim.keymap.set('n', '<F9>', dap.continue, {
                buffer = bufnr,
                desc = 'Java: Debug',
                noremap = true,
            })
        end
    end,
})

-- Auto-enable jdtls for Java files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
        vim.lsp.enable('jdtls')
    end,
})
