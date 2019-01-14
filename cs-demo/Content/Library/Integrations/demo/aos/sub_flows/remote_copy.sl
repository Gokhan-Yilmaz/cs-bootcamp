namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
  workflow:
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: " '/tmp'"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${host}'
        navigate:
          - SUCCESS: get_file
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      remote_secure_copy:
        x: 535
        y: 264
        navigate:
          4bab6e65-2d3e-9402-2489-cd579f0fa47d:
            targetId: ecc26c7a-78e5-3576-edf3-a78b041e2f8f
            port: SUCCESS
      get_file:
        x: 312
        y: 267
      extract_filename:
        x: 315
        y: 105
    results:
      SUCCESS:
        ecc26c7a-78e5-3576-edf3-a78b041e2f8f:
          x: 542
          y: 100
