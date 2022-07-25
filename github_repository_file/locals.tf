locals {
  branches_by_topic = {for branch in flatten([
    for k, v in data.github_repository.by_topic : [
      for b in v["branches"] : {
        repo: k,
        branch: b["name"]
      }
    ]
  ]) : "${branch["repo"]}__${branch["branch"]}" => branch}
  branches_by_name = {for branch in flatten([
    for k, v in data.github_repository.by_name : [
      for b in v["branches"] : {
        repo: k["name"],
        branch: b["name"]
      }
    ]
  ]) : "${branch["repo"]}__${branch["branch"]}" => branch}
}