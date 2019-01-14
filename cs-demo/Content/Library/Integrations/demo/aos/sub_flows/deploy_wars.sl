namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host
    - account_service_host
    - db_host
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - parameters: "db_host+' postgres admin '+tomcat_host+' '+account_service_host"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - parameters: "db_host+' postgres admin '+tomcat_host+' '+account_service_host"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 183
        y: 175
      deploy_tm_wars:
        x: 446
        y: 177
        navigate:
          936aba63-8ae0-0dd5-c9bb-d275c9753423:
            targetId: beb39d22-c645-98ec-e79e-73885536a733
            port: SUCCESS
    results:
      SUCCESS:
        beb39d22-c645-98ec-e79e-73885536a733:
          x: 644
          y: 184
