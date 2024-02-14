#!/bin/bash


dockerImageName=$(awk '/^FROM/ {print $2}' Dockerfile)


docker build -t temp_image_scan ${dockerImageName}


docker run --rm temp_image_scan anchore-cli image add temp_image_scan
docker run --rm temp_image_scan anchore-cli image wait temp_image_scan


vulnerabilities=$(docker run --rm temp_image_scan anchore-cli image vuln temp_image_scan os)
echo "$vulnerabilities"


if [[ "$vulnerabilities" == *"CRITICAL"* ]]; then
    echo "Image scanning failed. Critical vulnerabilities found."
    exit 1
else
    echo "Image scanning passed. No critical vulnerabilities found."
fi
