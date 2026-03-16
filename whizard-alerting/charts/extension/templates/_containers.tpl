{{- define "extension.ruler.configReloader.container" -}}
name: config-reloader
image: {{ include "extension.ruler.configReloader.image" . }}
{{- with .Values.ruler.configReloader.resources }}
resources:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}

{{- define "extension.ruler.writeProxy.container" -}}
name: write-proxy
image: {{ include "extension.ruler.writeProxy.image" . }}
{{- with .Values.ruler.writeProxy.resources }}
resources:
  {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}