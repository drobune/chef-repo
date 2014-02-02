=begin
run_list([
    "recipe[共通で実行するレシピ]"
])
default_attributes(
    "apache" => {
        "server_name" => "www.example.com"
        "port" => "80"
    }
)
=end
