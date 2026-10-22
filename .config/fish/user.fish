# Automatically load custom user completions and functions
if test -d $__fish_config_dir/user/completions
    set -gp fish_complete_path $__fish_config_dir/user/completions
end

if test -d $__fish_config_dir/user/functions
    set -gp fish_function_path $__fish_config_dir/user/functions
end
