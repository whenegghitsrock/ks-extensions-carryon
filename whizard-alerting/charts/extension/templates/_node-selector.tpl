{{- define "extension.common.nodeSelectors.nodeSelector" -}}
{{- if and .global .global.nodeSelector }}
    {{- $nodeSelector := .global.nodeSelector -}}
    {{- if .nodeSelector }}
        {{- $nodeSelector = merge .nodeSelector $nodeSelector -}}
    {{- end -}}
    {{- toYaml $nodeSelector }}
{{- else }}
    {{- toYaml .nodeSelector }}
{{- end }}
{{- end -}}

{{- define "extension.nodeSelector" -}}
{{- $_dict := (dict "nodeSelector" .Values.nodeSelector "global" .Values.global) }}
{{- include "extension.common.nodeSelectors.nodeSelector" $_dict }}
{{- end -}}

{{- define "extension.ruler.nodeSelector" -}}
{{- $_dict := (dict "nodeSelector" .Values.ruler.nodeSelector "global" .Values.global) }}
{{- include "extension.common.nodeSelectors.nodeSelector" $_dict }}
{{- end -}}