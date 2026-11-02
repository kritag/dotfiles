# oc-limits plugin
# Usage: ocpl <project_name>
function ocpl() {
  local project_name=$1
  test -n "${project_name}" && local namespace="--namespace=${project_name}" || local namespace=""
  oc get pods $namespace --no-headers=true -o custom-columns="STATE:.status.phase,NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory,CPU_LIMIT:.spec.containers[*].resources.limits.cpu,MEM_LIMIT:.spec.containers[*].resources.limits.memory" |
    awk 'BEGIN { printf "%-9s %-50s %-9s %-9s %-11s %-11s\n", "STATE", "NAME", "CPU_REQ", "MEM_REQ", "CPU_LIMIT", "MEM_LIMIT" }
         { printf "%-9s %-50.50s %-9s %-9s %-11s %-11s\n", $1, $2, $3, $4, $5, $6 }'
}
