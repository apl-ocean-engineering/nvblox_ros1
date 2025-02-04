# docker buildx bake
group "default" {
  targets = ["core", "base"]
}

target "core" {
  target = "core"
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64"]
  tags       = [
    "registry.gitlab.com/apl-ocean-engineering/raven/manipulation/mapping/nvblox:core",
  ]
}

target "base" {
  target = "base"
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64"]
  tags       = [
    "registry.gitlab.com/apl-ocean-engineering/raven/manipulation/mapping/nvblox:base",
  ]
  output = ["type=docker"]
}
