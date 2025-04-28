{
  "version": "10",
  "aliases": {
    "myminio": {
      "url": "${main_endpoint}",
      "accessKey": "${access_key}",
      "secretKey": "${secret_key}",
      "api": "s3v4",
      "path": "auto"
    },
    %{ for node in nodes ~}
    "${node.name}": {
      "url": "${node.url}",
      "accessKey": "${access_key}",
      "secretKey": "${secret_key}",
      "api": "s3v4",
      "path": "auto"
    }${!node.last ? "," : ""}
    %{ endfor ~}
  }
}