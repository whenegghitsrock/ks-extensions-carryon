{{- define "extension.common.images.image" -}}
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

{{- define "extension.apiserver.image" -}}
{{- $_dict := (dict "imageRoot" .Values.apiserver.image "global" .Values.global) }}
{{- if empty $_dict.imageRoot.tag }}
    {{- $_ := set $_dict.imageRoot "tag" .Chart.AppVersion }}
{{- end }}
{{- include "extension.common.images.image" $_dict }}
{{- end -}}

{{- define "extension.controllerManager.image" -}}
{{- $_dict := (dict "imageRoot" .Values.controllerManager.image "global" .Values.global) }}
{{- if empty $_dict.imageRoot.tag }}
    {{- $_ := set $_dict.imageRoot "tag" .Chart.AppVersion }}
{{- end }}
{{- include "extension.common.images.image" $_dict }}
{{- end -}}

{{- define "extension.ruler.image" -}}
{{ include "extension.common.images.image" (dict "imageRoot" .Values.ruler.image "global" .Values.global) }}
{{- end -}}

{{- define "extension.ruler.configReloader.image" -}}
{{ include "extension.common.images.image" (dict "imageRoot" .Values.ruler.configReloader.image "global" .Values.global) }}
{{- end -}}

{{- define "extension.ruler.writeProxy.image" -}}
{{ include "extension.common.images.image" (dict "imageRoot" .Values.ruler.writeProxy.image "global" .Values.global) }}
{{- end -}}

{{- define "extension.kubectl.image" -}}
{{ include "extension.common.images.image" (dict "imageRoot" .Values.kubectl.image "global" .Values.global) }}
{{- end -}}

{{- define "extension.imagePullSecrets" -}}
{{- if .Values.imagePullSecrets }}
    {{- toYaml .Values.imagePullSecrets }}
{{- else if and .Values.global .Values.global.imagePullSecrets }}
    {{- toYaml .Values.global.imagePullSecrets }}
{{- end }}
{{- end -}}

{{- define "extension.ruler.imagePullSecrets" -}}
{{- if .Values.ruler.imagePullSecrets }}
    {{- toYaml .Values.ruler.imagePullSecrets }}
{{- else if and .Values.global .Values.global.imagePullSecrets }}
    {{- toYaml .Values.global.imagePullSecrets }}
{{- end }}
{{- end -}}