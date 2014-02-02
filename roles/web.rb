#nodes/*.jsonで定義されてる”chef_environment”の値を取得する
@environment = "_default"
node_index = ARGV.index('-j') 
if node_index
    require 'json'
    node_json = JSON.parse(File.read(ARGV[node_index+1]))
    if node_json["chef_environment"]
        @environment = node_json["chef_environment"]
    end
end
#共通の設定、dev用設定を記述
=begin
env_run_lists = {}
env_run_lists["_default"] = [
    "role[common]",   ※web,db共通のセットアップ・設定
    "recipe[apache]", ※web.rbなのでapacheをインストール
]
env_run_lists["_dev"] = env_run_lists['_default'] + [
    "role[_dev]"      ※dev環境用の設定roleを読み込み
]
default_attributes(
    "apache" => {
        "port" => "443"
    }
)
=end
#run_list(env_run_lists[@environment])
