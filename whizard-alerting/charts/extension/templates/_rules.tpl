{{- /*
Generated file. Do not change in-place! In order to change this file first read following link:
https://github.com/WhizardTelemetry/WhizardAlerting/tree/main/charts/whizard-alerting/hack
*/ -}}
{{- define "rules.names" }}
rules:
  - "alertmanager-rules"
  - "config-reloaders"
  - "etcd"
  - "general-rules"
  - "kube-apiserver-slos"
  - "kube-state-metrics"
  - "kubernetes-apps"
  - "kubernetes-resources"
  - "kubernetes-storage"
  - "kubernetes-system"
  - "kubernetes-system-kube-proxy"
  - "kubernetes-system-apiserver"
  - "kubernetes-system-kubelet"
  - "kubernetes-system-controller-manager"
  - "kubernetes-system-scheduler"
  - "node-exporter"
  - "node-network"
  - "prometheus-operator"
  - "prometheus"
  - "ks-apiserver"
  - "ks-controller-manager"
  - "kubesphere-system"
  - "thanos-rule"
  - "thanos-query"
  - "thanos-receive"
  - "thanos-store"
  - "thanos-compact"
  - "thanos-sidecar"
  - "thanos-bucket-replicate"
  - "thanos-component-absent"
  - "calico-exporter-rules"
  - "process-exporter-rules"
{{- end }}