package :mongodb, :provides => :database do
  description 'MongoDB'
  version '1.2.1'
  MONGO_PATH = "/usr/local/mongodb"
 
  binaries = %w(mongo mongod mongodump mongoexport mongofiles mongoimport mongorestore mongos mongosniff)
  source "http://downloads.mongodb.org/linux/mongodb-linux-x86_64-#{version}.tgz" do
    binaries.each {|bin| post :install, "ln -s #{MONGO_PATH}/bin/#{bin} /usr/local/bin/#{bin}"}
  end
  
  push_text File.read(File.join(File.dirname(__FILE__), 'mongodb', 'init.d')), "/etc/init.d/mongodb", :sudo => true do
    post :install, "sudo chmod +x /etc/init.d/mongodb"
    # post :install, "sudo /usr/sbin/update-rc.d -f mongodb defaults"
    # post :install, "sudo /etc/init.d/nginx mongodb"
  end
  
  verify do
    has_directory install_path
    binaries.each {|bin| has_symlink "/usr/local/bin/#{bin}", "#{MONGO_PATH}/bin/#{bin}" }
  end
  
  requires :ruby_enterprise
end
