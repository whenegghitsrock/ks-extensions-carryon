{{/*
Defines the PodSpec for Vector.
*/}}
{{- define "vector.pod" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "vector.serviceAccountName" . }}
{{- with .Values.podHostNetwork }}
hostNetwork: {{ . }}
{{- end }}
{{- with .Values.podSecurityContext }}
securityContext:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.podPriorityClassName }}
priorityClassName: {{ . }}
{{- end }}
{{- with .Values.shareProcessNamespace }}
shareProcessNamespace: {{ . }}
{{- end }}
{{- with .Values.dnsPolicy }}
dnsPolicy: {{ . }}
{{- end }}
{{- with .Values.dnsConfig }}
dnsConfig:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.image.pullSecrets }}
imagePullSecrets:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.initContainers }}
initContainers:
{{ toYaml . | indent 2 }}
{{- end }}
containers:
  - name: vector
{{- with .Values.securityContext }}
    securityContext:
{{ toYaml . | indent 6 }}
{{- end }}
{{- if .Values.image.sha }}
    image: "{{- include "global.imageRegistry" . }}{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}@sha256:{{ .Values.image.sha }}"
{{- else }}
    image: "{{- include "global.imageRegistry" . }}{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
{{- end }}
    imagePullPolicy: {{ .Values.image.pullPolicy }}
{{- with .Values.command }}
    command:
    {{- toYaml . | nindent 6 }}
{{- end }}
{{- with .Values.args }}
    args:
    {{- toYaml . | nindent 6 }}
{{- end }}
    env:
      - name: VECTOR_LOG
        value: "{{ .Values.logLevel | default "info" }}"
{{- if .Values.env }}
{{- with .Values.env }}
    {{- toYaml . | nindent 6 }}
{{- end }}
{{- end }}
{{- if (eq .Values.role "Agent") }}
      - name: VECTOR_SELF_NODE_NAME
        valueFrom:
          fieldRef:
            fieldPath: spec.nodeName
      - name: VECTOR_SELF_POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: VECTOR_SELF_POD_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: PROCFS_ROOT
        value: "/host/proc"
      - name: SYSFS_ROOT
        value: "/host/sys"
{{- end }}
{{- if .Values.envFrom }}
{{- with .Values.envFrom }}
    envFrom:
    {{- toYaml . | nindent 6 }}
{{- end }}
{{- end }}
    ports:
{{- if or .Values.containerPorts .Values.existingConfigMaps }}
    {{- toYaml .Values.containerPorts | nindent 6 }}
{{- else if .Values.customConfig }}
    {{- include "vector.containerPorts" . | indent 6 }}
{{- else if or (eq .Values.role "Aggregator") (eq .Values.role "Stateless-Aggregator") }}
      - name: api
        containerPort: 8686
        protocol: TCP
      - name: vector
        containerPort: 6000
        protocol: TCP
      - name: http
        containerPort: 6001
        protocol: TCP
{{- else if (eq .Values.role "Agent") }}
      - name: prom-exporter
        containerPort: 9090
        protocol: TCP
{{- end }}
{{- with .Values.livenessProbe }}
    livenessProbe:
      {{- toYaml . | trim | nindent 6 }}
{{- end }}
{{- with .Values.readinessProbe }}
    readinessProbe:
      {{- toYaml . | trim | nindent 6 }}
{{- end }}
{{- with .Values.resources }}
    resources:
{{- toYaml . | nindent 6 }}
{{- end }}
{{- with .Values.lifecycle }}
    lifecycle:
{{- toYaml . | nindent 6 }}
{{- end }}
    volumeMounts:
      - name: {{ .Values.vectorConfig.voulumeMounts.name }}
        mountPath: {{ .Values.vectorConfig.voulumeMounts.mountPath }}
        readOnly: true
      - name: data
        {{- if .Values.existingConfigMaps }}
        mountPath: "{{ if .Values.dataDir }}{{ .Values.dataDir }}{{ else }}{{ fail "Specify `dataDir` if you're using `existingConfigMaps`" }}{{ end }}"
        {{- else }}
        mountPath: "{{ .Values.customConfig.data_dir | default "/vector-data-dir" }}"
        {{- end }}
      - name: global-config
        mountPath: "/etc/vector/global"
        readOnly: true
{{- if (eq .Values.role "Agent") }}
{{- with .Values.defaultVolumeMounts }}
{{- toYaml . | nindent 6 }}
{{- end }}
{{- end }}
{{- with .Values.extraVolumeMounts }}
{{- toYaml . | nindent 6 }}
{{- end }}
{{- with .Values.extraContainers }}
{{ toYaml . | indent 2 }}
{{- end }}
terminationGracePeriodSeconds: {{ .Values.terminationGracePeriodSeconds }}
{{- include "common.nodeSelectors" . }}
{{- with .Values.affinity }}
affinity:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with .Values.tolerations }}
tolerations:
{{ toYaml . | indent 2 }}
{{- end }}
{{- with  .Values.topologySpreadConstraints }}
topologySpreadConstraints:
{{- toYaml . | nindent 2 }}
{{- end }}
volumes:
  - name: {{ .Values.vectorConfig.voulumeMounts.name }}
    emptyDir: {}
{{- if and .Values.persistence.enabled (eq .Values.role "Aggregator") }}
{{- with .Values.persistence.existingClaim }}
  - name: data
    persistentVolumeClaim:
      claimName: {{ . }}
{{- end }}
{{- else if (ne .Values.role "Agent") }}
  - name: data
    emptyDir: {}
{{- end }}
  - name: global-config
    projected:
      sources:
{{- if .Values.existingConfigMaps }}
  {{- range .Values.existingConfigMaps }}
        - configMap:
            name: {{ . }}
  {{- end }}
{{- else }}
        - configMap:
            name: {{ template "vector.fullname" . }}
{{- end }}
{{- if (eq .Values.role "Agent") }}
  - name: data
  {{- if .Values.persistence.hostPath.enabled }}
    hostPath:
      path: {{ .Values.persistence.hostPath.path | quote }}
  {{- else }}
    emptyDir: {}
  {{- end }}
    {{- with .Values.defaultVolumes }}
    {{- toYaml . | nindent 2 }}
    {{- end }}
{{- end }}
{{- with .Values.extraVolumes }}
{{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}
