#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <namespace> <replicas>"
    echo "Ejemplo: $0 jenkins2025 0"
    exit 1
fi

NAMESPACE="$1"
REPLICAS="$2"

# Validación del número de réplicas
if ! [[ "$REPLICAS" =~ ^[0-9]+$ ]]; then
    echo "Error: el número de réplicas debe ser un número entero."
    exit 2
fi

echo "🔍 Buscando Deployments en el namespace '$NAMESPACE'..."
DEPLOYMENTS=$(kubectl get deployments -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

echo "🔍 Buscando StatefulSets en el namespace '$NAMESPACE'..."
STATEFULSETS=$(kubectl get statefulsets -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

# Escalar Deployments
for DEPLOY in $DEPLOYMENTS; do
    echo "⚙️ Escalando Deployment '$DEPLOY' a $REPLICAS réplicas..."
    kubectl scale deployment "$DEPLOY" -n "$NAMESPACE" --replicas="$REPLICAS"
done

# Escalar StatefulSets
for STS in $STATEFULSETS; do
    echo "⚙️ Escalando StatefulSet '$STS' a $REPLICAS réplicas..."
    kubectl scale statefulset "$STS" -n "$NAMESPACE" --replicas="$REPLICAS"
done

echo "✅ Escalado completado para el namespace '$NAMESPACE'."
