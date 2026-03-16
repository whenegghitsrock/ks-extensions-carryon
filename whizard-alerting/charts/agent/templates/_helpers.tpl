{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- if contains .Chart.Name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "agent.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the KubeSphere service account to use
*/}}
{{- define "agent.ksServiceAccountName" -}}
{{- default (include "agent.fullname" .) .Values.global.ksServiceAccount.name }}
{{- end }}

{{/*
Annotations for crds update hook
*/}}
{{- define "agent.updateCrdsHook.annotations" -}}
"helm.sh/hook": pre-install,pre-upgrade
"helm.sh/hook-weight": "-5"
"helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
{{- end }}

{{/*
The distribution mode which is default to Member
*/}}
{{- define "agent.distributionMode" -}}
{{- if and .Values.global .Values.global.rules .Values.global.rules.distributionMode }}
  {{- default "Member" .Values.global.rules.distributionMode }}
{{- else }}
  {{- print "Member" }}
{{- end }}
{{- end }}

{{- define "agent.ruler.remoteWriteConfig" -}}
  {{- if eq (include "agent.distributionMode" .) "Member" -}}
    {{- $replicas := 0 -}}
    {{- if .Values.ruler.prometheus.replicasAutoGet }}
      {{- $prometheusCr := lookup "monitoring.coreos.com/v1" "Prometheus" .Values.ruler.prometheus.namespace .Values.ruler.prometheus.name -}}
      {{- if and $prometheusCr $prometheusCr.spec -}}
        {{- if $prometheusCr.spec.replicas -}}
          {{- $replicas = $prometheusCr.spec.replicas -}}
        {{- else -}}
          {{- $replicas = 1}}
        {{- end }}
      {{- end }}
    {{- else -}}
      {{- $replicas = .Values.ruler.prometheus.replicas -}}
    {{- end }}
    {{- if gt (int $replicas) 0 -}}
remote_write:
      {{- range $i := until (int $replicas) }}
- url: http://prometheus-{{ $.Values.ruler.prometheus.name }}-{{ $i }}.prometheus-operated.{{ $.Values.ruler.prometheus.namespace }}.svc:{{ $.Values.ruler.prometheus.port }}/api/v1/write
      {{- end }}
     {{- end }}
  {{- end }}
{{- end -}}