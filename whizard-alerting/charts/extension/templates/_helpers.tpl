{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If .Values.fullnameOverride is empty, use .Release.Name as fullname.
*/}}
{{- define "extension.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "extension.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "extension.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "extension.selectorLabels" -}}
app.kubernetes.io/name: {{ include "extension.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "extension.labels" -}}
helm.sh/chart: {{ include "extension.chart" . }}
{{ include "extension.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "extension.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "extension.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the KubeSphere service account to use
*/}}
{{- define "extension.ksServiceAccountName" -}}
{{- if .Values.ksServiceAccount.create }}
{{- default (include "extension.fullname" .) .Values.ksServiceAccount.name }}
{{- else }}
{{- default "default" .Values.ksServiceAccount.name }}
{{- end }}
{{- end }}

{{/*
The distribution mode which is default to Member
*/}}
{{- define "extension.distributionMode" -}}
{{- if and .Values.global .Values.global.rules .Values.global.rules.distributionMode }}
  {{- default "Member" .Values.global.rules.distributionMode }}
{{- else }}
  {{- print "Member" }}
{{- end }}
{{- end }}