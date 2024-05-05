# Audiobookshelf Helm Chart

This Helm chart deploys the Audiobookshelf server on a Kubernetes cluster, allowing you to serve audiobooks, ebooks, and podcasts from NFS shares.

## Installation

To install Audiobookshelf using this Helm chart, follow these steps:

### Step 1: Prepare Configuration

Create a `custom.yaml` file to override the default configuration settings. Below is an example configuration that integrates Audiobookshelf with Traefik for ingress, and configures readonly NFS shares where the media files are stored.

```yaml
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: traefik
  hosts:
    - host: audiobooks.my-domain.com
      paths:
        - path: /
          pathType: ImplementationSpecific

nfs:
  - server: 192.168.0.30
    storage: 1Ti
    name: my-nfs-server
    share:
      - name: audiobooks
        path: /volume1/audiobooks
        mountPath: /audiobooks
```

If required the version of the Audiobookshelf image can be overridden by setting the `image.tag` value in the `custom.yaml` file.

```yaml
image:
  repository: ghcr.io/audiobookshelf/audiobookshelf
  tag: 9.8.7
  pullPolicy: IfNotPresent
```

#### Add the helm repository

The Audiobookshelf Helm chart is hosted in the GitLab Package Registry. To add the repository to Helm, use the following command:

```bash
helm repo add audiobookshelf https://gitlab.com/api/v4/projects/57546317/packages/helm/release
```

It is possible to use pre-release versions of the chart by replacing `release` with the pre-release channel name. The following pre-release channels are available:

- `nightly`
- `preview`
- `rc`

> **Note:** The pre-release channels may contain unstable or untested versions of the chart.

### Step 2: Deploy

Run the following Helm command to deploy Audiobookshelf with the custom configuration.

> **Note:** If a pre-release channel is used, add `--devel` to the Helm command.

```bash
helm install \
  --create-namespace \
  --namespace audiobookshelf \
  audiobookshelf \
  -f custom.yaml \
  audiobookshelf/audiobookshelf
```

## Upgrades

To upgrade your Audiobookshelf deployment to a new version or to apply configuration changes, use the following command:

```bash
helm upgrade \
  --namespace audiobookshelf \
  audiobookshelf \
  -f custom.yaml \
  audiobookshelf/audiobookshelf
```

## Managing NFS Mounts

If you need to update the NFS mount configuration, follow these steps:

1. Comment out the NFS mount configuration in `custom.yaml` that needs adjustment.
2. Upgrade the Helm deployment using the command provided in the Upgrades section.
3. Make the required changes to your NFS setup.
4. Uncomment the adjusted NFS mount configuration.
5. Upgrade the Helm deployment again to apply the changes.

## Additional Information

For more detailed configuration options and advanced setups, refer to the chart's `values.yaml` file and the Audiobookshelf documentation.

