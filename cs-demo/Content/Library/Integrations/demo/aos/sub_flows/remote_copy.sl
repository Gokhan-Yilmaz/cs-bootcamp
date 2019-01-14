namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
          - FAILURE: on_failure
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
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 321
        y: 108
      get_file:
        x: 312
        y: 267
      remote_secure_copy:
        x: 535
        y: 264
        navigate:
          4bab6e65-2d3e-9402-2489-cd579f0fa47d:
            targetId: ecc26c7a-78e5-3576-edf3-a78b041e2f8f
            port: SUCCESS
    results:
      SUCCESS:
        ecc26c7a-78e5-3576-edf3-a78b041e2f8f:
          x: 542
          y: 100
