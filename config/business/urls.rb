URLS = YAML::load(File.open(File.join('config', 'business', "urls.yml")))
SCHEME = URLS[Rails.env]["scheme"]
SUBDOMAIN = URLS[Rails.env]["subdomain"]
DOMAIN = URLS[Rails.env]["domain"]
PORT = URLS[Rails.env]["port"]
ROOT_URI = URI.parse("#{SCHEME}://#{SUBDOMAIN.blank? ? "" : SUBDOMAIN + "."}#{DOMAIN}#{PORT == '80' ? "" : ":" + PORT}")
ROOT_URL = ROOT_URI.to_s
