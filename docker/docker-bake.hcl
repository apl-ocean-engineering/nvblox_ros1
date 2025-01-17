# docker buildx bake
group "default" {
  targets = ["core"]
}

target "core" {
  target = "core"
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64"]
  tags       = [
    "nvblox:latest",
  ]
}

