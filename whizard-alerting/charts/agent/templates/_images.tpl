{{- define "agent.common.images.image" -}}
{{- $registryName := "" }}
{{- if and .global .global.imageRegistry }}
    {{- $registryName = .global.imageRegistry }}
{{- end }}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := "" -}}
{{- if and .global .global.tag }}
    {{- $termination = .global.tag | toString }}
{{- end }}
{{- if .imageRoot.registry }}
    {{- $registryName = .imageRoot.registry -}}
{{- end -}}
{{- if empty $registryName }}
    {{- if .imageRoot.defaultRegistry }}
        {{- $registryName = .imageRoot.defaultRegistry }}
    {{- end -}}
{{- end -}}
{{- if .imageRoot.tag }}
    {{- $termination = .imageRoot.tag | toString -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else }}
    {{- printf "%s%s%s" $repositoryName $separator $termination -}}
{{- end }}
{{- end -}}

{{- define "agent.ruler.image" -}}
{{ include "agent.common.images.image" (dict "imageRoot" .Values.ruler.image "global" .Values.global) }}
{{- end -}}

{{- define "agent.ruler.configReloader.image" -}}
{{ include "agent.common.images.image" (dict "imageRoot" .Values.ruler.configReloader.image "global" .Values.global) }}
{{- end -}}

{{- define "agent.kubectl.image" -}}
{{ include "agent.common.images.image" (dict "imageRoot" .Values.kubectl.image "global" .Values.global) }}
{{- end -}}

{{- define "agent.ruler.imagePullSecrets" -}}
{{- if .Values.ruler.imagePullSecrets }}
    {{- toYaml .Values.ruler.imagePullSecrets }}
{{- else if and .Values.global .Values.global.imagePullSecrets }}
    {{- toYaml .Values.global.imagePullSecrets }}
{{- end }}
{{- end -}}