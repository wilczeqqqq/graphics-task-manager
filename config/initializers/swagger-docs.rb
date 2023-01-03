include Swagger::Docs::ImpotentMethods

# Swagger::Docs::Config.register_apis(
#   {
#     "1.0" => {
#       :api_extension_type => :json,
#       :api_file_path => "public/",
#       :base_path => "http://localhost:3000",
#       :clean_directory => true,
#       :attributes => {
#         :info => {
#           "title" => "Graphics Task Manager",
#           "description" => "Rails REST API"
#         }
#       }
#     }
#   })

class Swagger::Docs::Config
  def self.base_api_controller
    ActionController::API
  end
end
