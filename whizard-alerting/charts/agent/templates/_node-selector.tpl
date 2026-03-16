{{- define "agent.common.nodeSelectors.nodeSelector" -}}
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

{{- define "agent.ruler.nodeSelector" -}}
{{- $_dict := (dict "nodeSelector" .Values.ruler.nodeSelector "global" .Values.global) }}
{{- include "agent.common.nodeSelectors.nodeSelector" $_dict }}
{{- end -}}