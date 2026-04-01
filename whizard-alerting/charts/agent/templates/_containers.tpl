{{- define "agent.ruler.configReloader.container" -}}
name: config-reloader
image: {{ include "agent.ruler.configReloader.image" . }}
{{- with .Values.ruler.configReloader.resources }}
resources:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}