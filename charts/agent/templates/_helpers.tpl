{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Use the fullname if the serviceAccount value is not set
*/}}
{{- define "agent.serviceAccount" -}}
{{- if .Values.serviceAccount }}
{{- .Values.serviceAccount -}}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "agent.image" -}}
{{- if .Values.USE_EBPF }}
{{- .Values.ebpf_agent.image.repository -}}:{{- .Values.ebpf_agent.image.tag -}}
{{- else -}}
{{- .Values.agent.image.repository -}}:{{- .Values.agent.image.tag -}}
{{- end -}}
{{- end -}}

{{- define "agent.imagePullPolicy" -}}
{{- if .Values.USE_EBPF }}
{{- .Values.ebpf_agent.image.pullPolicy -}}
{{- else -}}
{{- .Values.agent.image.pullPolicy -}}
{{- end -}}
{{- end -}}

{{- define "process-sampler.image" -}}
{{- if .Values.USE_EBPF }}
{{- .Values.ebpf_agent.process_sampler.repository -}}:{{- .Values.ebpf_agent.process_sampler.tag -}}
{{- else -}}
{{- .Values.agent.process_sampler.repository -}}:{{- .Values.agent.process_sampler.tag -}}
{{- end -}}
{{- end -}}

{{- define "metric-sampler.image" -}}
{{- if .Values.USE_EBPF }}
{{- .Values.ebpf_agent.metric_sampler.repository -}}:{{- .Values.ebpf_agent.metric_sampler.tag -}}
{{- else -}}
{{- .Values.agent.metric_sampler.repository -}}:{{- .Values.agent.metric_sampler.tag -}}
{{- end -}}
{{- end -}}

{{- define "networkAndPid" -}}
{{- if .Values.USE_EBPF }}
hostPID: true
hostNetwork: true
dnsPolicy: ClusterFirstWithHostNet
{{- else -}}
hostPID: false
hostNetwork: false
{{- end -}}
{{- end -}}
