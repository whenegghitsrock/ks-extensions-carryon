{{/*
Expand the name of the chart.
*/}}
{{- define "whizard-telemetry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "whizard-telemetry.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "whizard-telemetry.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "whizard-telemetry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "whizard-telemetry.labels" -}}
helm.sh/chart: {{ include "whizard-telemetry.chart" . }}
{{ include "whizard-telemetry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "whizard-telemetry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "whizard-telemetry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "whizard-telemetry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "whizard-telemetry.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the KubeSphere service account to use
*/}}
{{- define "whizard-telemetry.ksServiceAccountName" -}}
{{- if .Values.ksServiceAccount.create }}
{{- default (include "whizard-telemetry.fullname" .) .Values.ksServiceAccount.name }}
{{- else }}
{{- default "default" .Values.ksServiceAccount.name }}
{{- end }}
{{- end }}

{{- define "whizard-telemetry.common.nodeSelectorFunc" -}}
{{- if .globalNodeSelector }}
    {{- $nodeSelector := .globalNodeSelector -}}
    {{- if .nodeSelector }}
        {{- $nodeSelector = merge .nodeSelector $nodeSelector -}}
    {{- end -}}
    {{- toYaml $nodeSelector }}
{{- else }}
    {{- toYaml .nodeSelector }}
{{- end }}
{{- end -}}

{{- define "whizard-telemetry.apiserver.nodeSelector" -}}
{{- $_dict := (dict "nodeSelector" .Values.apiserver.nodeSelector "globalNodeSelector" .Values.global.nodeSelector) }}
{{- include "whizard-telemetry.common.nodeSelectorFunc" $_dict }}
{{- end -}}