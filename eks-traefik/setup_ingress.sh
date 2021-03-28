#!/bin/bash 

cat > ingress.yaml <<EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: default-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - host: $1
      http:
        paths:
          - path: /*
            backend:
              serviceName: service-2048
              servicePort: 80
EOF