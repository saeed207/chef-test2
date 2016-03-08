#By saeed

include_recipe 'deploy'

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
 end

execute 'deployment_cleanup' do
  command 'rm -rf config log tmp public'
  cwd "/usr/local/apache-tomcat/latest/webapps"
 end

end
