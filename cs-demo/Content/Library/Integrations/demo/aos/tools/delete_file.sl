namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      delete_file:
        x: 383
        y: 231
        navigate:
          4b30af83-14b3-65f9-6202-94b03c620d9e:
            targetId: e76a928d-9339-081a-5e62-157d930ff6b6
            port: SUCCESS
    results:
      SUCCESS:
        e76a928d-9339-081a-5e62-157d930ff6b6:
          x: 601
          y: 236
