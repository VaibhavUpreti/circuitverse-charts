{{/*
Expand the name of the chart.
*/}}
{{- define "circuitverse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "circuitverse.fullname" -}}
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
{{- define "circuitverse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "circuitverse.labels" -}}
helm.sh/chart: {{ include "circuitverse.chart" . }}
{{ include "circuitverse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "circuitverse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "circuitverse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "circuitverse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "circuitverse.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "circuitverse.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "circuitverse-postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "circuitverse.redis.fullname" -}}
{{- if .Values.redis.fullnameOverride -}}
{{- .Values.redis.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.redis.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "circuitverse-redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "circuitverse.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "circuitverse.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "circuitverse.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "circuitverse.postgresql.fullname" . -}}
{{- else -}}
{{- template "circuitverse.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "circuitverse.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.auth.secretKeys.adminPasswordKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "circuitverse.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
    5432
{{- else -}}
{{- default 5432 .Values.postgresql.postgresqlPort -}}
{{- end -}}
{{- end -}}

{{/*
Set redis host
*/}}
{{- define "circuitverse.redis.host" -}}
{{- if .Values.redis.enabled -}}
{{- template "circuitverse.redis.fullname" . -}}-master
{{- else -}}
{{- .Values.redis.host }}
{{- end -}}
{{- end -}}

{{/*
Set redis secret
*/}}
{{- define "circuitverse.redis.secret" -}}
{{- if .Values.redis.enabled -}}
{{- template "circuitverse.redis.fullname" . -}}
{{- else -}}
{{- template "circuitverse.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set redis secretKey
*/}}
{{- define "circuitverse.redis.secretKey" -}}
{{- if .Values.redis.enabled -}}
"redis-password"
{{- else -}}
{{- default "redis-password" .Values.redis.existingSecretPasswordKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "circuitverse.redis.port" -}}
{{- if .Values.redis.enabled -}}
    6379
{{- else -}}
{{- default 6379 .Values.redis.port -}}
{{- end -}}
{{- end -}}

{{/*
Set redis password
*/}}
{{- define "circuitverse.redis.password" -}}
{{- if .Values.redis.enabled -}}
{{- default "redis" .Values.redis.auth.password -}}
{{- else -}}
{{- default "redis" .Values.redis.password -}}
{{- end -}}
{{- end -}}

{{/*
Set redis URL
*/}}
{{- define "circuitverse.redis.url" -}}
{{- if .Values.redis.enabled -}}
    redis://:{{ .Values.redis.auth.password }}@{{ template "circuitverse.redis.host" . }}:{{ template "circuitverse.redis.port" . }}
{{- else if .Values.env.REDIS_TLS -}}
    rediss://:$(REDIS_PASSWORD)@{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
    redis://:$(REDIS_PASSWORD)@{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- end -}}
{{- end -}}

