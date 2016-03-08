#By saeed

include_recipe 'deploy'

service "apache2" do
  action [ :stop ]
end

bash "stop_tomcat" do
  user "root"
  code do
    for (( ; ; ));do java=''; java=`ps -ef | grep java | grep -vi grep | awk '{print $2}'`; if [ $java != "" ]; then pkill -15 java; else break; fi; done
  end
end

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

execute 'deployment_finalization' do
  command 'cp -r /usr/local/apache-tomcat/latest/opsworks-deployment/current/* /usr/local/apache-tomcat/latest/webapps/'
  cwd "/usr/local/apache-tomcat/latest/webapps"
  user "tomcat"
  group "tomcat"
 end



execute 'deployment_cleanup' do
  command 'rm -rf config log tmp public'
  cwd "/usr/local/apache-tomcat/latest/webapps"
 end

end
