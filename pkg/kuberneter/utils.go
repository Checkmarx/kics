package kuberneter

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	appsv1 "k8s.io/api/apps/v1"
	appsv1beta1 "k8s.io/api/apps/v1beta1"
	appsv1beta2 "k8s.io/api/apps/v1beta2"
	batchv1 "k8s.io/api/batch/v1"
	batchv1beta1 "k8s.io/api/batch/v1beta1"
	corev1 "k8s.io/api/core/v1"
	networkingv1 "k8s.io/api/networking/v1"
	networkingv1beta1 "k8s.io/api/networking/v1beta1"
	policyv1 "k8s.io/api/policy/v1"
	policyv1beta1 "k8s.io/api/policy/v1beta1"
	rbacv1 "k8s.io/api/rbac/v1"
	rbacv1alpha1 "k8s.io/api/rbac/v1alpha1"
	rbacv1beta1 "k8s.io/api/rbac/v1beta1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/serializer/json"
	"k8s.io/client-go/kubernetes/scheme"
)

// K8sAPIOptions saves all the necessary information to list the resources
type K8sAPIOptions struct {
	Namespaces  []string
	APIVersions []string
	Kinds       []string
}

const (
	kuberneterPathLength = 3
	dirPerms             = 0777
	filePerms            = 0777
)

func (info *k8sAPICall) saveK8sResources(kind, k8sResourcesContent, apiVersionFolder string) {
	file := filepath.Join(apiVersionFolder, kind+"s"+".yaml")

	f, err := os.OpenFile(filepath.Clean(file), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, filePerms)

	if err != nil {
		log.Error().Msgf("failed to open file '%s': %s", file, err)
	}

	if _, err = f.WriteString(k8sResourcesContent); err != nil {
		log.Error().Msgf("failed to write file '%s': %s", file, err)
	}

	err = f.Close()
	if err != nil {
		log.Err(err).Msgf("failed to close file: %s", file)
	}
}

func (info *k8sAPICall) getResource(o runtime.Object, apiVersion, kind string, sb *strings.Builder) *strings.Builder {
	e := json.NewSerializerWithOptions(json.DefaultMetaFactory, scheme.Scheme, scheme.Scheme, json.SerializerOptions{})

	begin := fmt.Sprintf("\n---\napiVersion: %s\nkind: %s\n", getAPIVersion(apiVersion), kind)

	if _, err := sb.WriteString(begin); err != nil {
		log.Err(err).Msg("failed to write")
	}

	if err := e.Encode(o, sb); err != nil {
		log.Err(err).Msg("failed to encode")
	}

	return sb
}

func extractK8sAPIOptions(path string, supportedKinds *supportedKinds) (*K8sAPIOptions, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != kuberneterPathLength {
		return &K8sAPIOptions{}, errors.New("wrong kuberneter path syntax")
	}

	k8sAPIOptions := &K8sAPIOptions{
		Namespaces:  strings.Split(pathInfo[0], "+"),
		APIVersions: strings.Split(pathInfo[1], "+"),
		Kinds:       strings.Split(pathInfo[2], "+"),
	}

	supAPIVersions, supKinds := getSupportedOptions(supportedKinds)

	for i := range k8sAPIOptions.APIVersions {
		if !utils.Contains(k8sAPIOptions.APIVersions[i], *supAPIVersions) {
			return &K8sAPIOptions{}, errors.New("wrong apiVersion: " + k8sAPIOptions.APIVersions[i])
		}
	}

	for i := range k8sAPIOptions.Kinds {
		if !utils.Contains(k8sAPIOptions.Kinds[i], *supKinds) {
			return &K8sAPIOptions{}, errors.New("wrong kind: " + k8sAPIOptions.Kinds[i])
		}
	}

	if k8sAPIOptions.Namespaces[0] == "*" {
		k8sAPIOptions.Namespaces[0] = ""
	}

	return k8sAPIOptions, nil
}

func getNamespace(namespace string) string {
	if namespace == "" {
		return "all namespaces"
	}

	return fmt.Sprintf("the namespace %s", namespace)
}

func buildSupportedKinds() *supportedKinds {
	supportedKinds := &supportedKinds{
		"apps/v1": {
			"DaemonSet":   &appsv1.DaemonSetList{},
			"Deployment":  &appsv1.DeploymentList{},
			"ReplicaSet":  &appsv1.ReplicaSetList{},
			"StatefulSet": &appsv1.StatefulSetList{},
		},
		"core/v1": {
			"LimitRange":            &corev1.LimitRangeList{},
			"Pod":                   &corev1.PodList{},
			"PersistentVolume":      &corev1.PersistentVolumeList{},
			"PersistentVolumeClaim": &corev1.PersistentVolumeClaimList{},
			"ReplicationController": &corev1.ReplicationControllerList{},
			"ResourceQuota":         &corev1.ResourceQuotaList{},
			"Secret":                &corev1.SecretList{},
			"ServiceAccount":        &corev1.ServiceAccountList{},
			"Service":               &corev1.ServiceList{},
		},
		"batch/v1": {
			"CronJob": &batchv1.CronJobList{},
			"Job":     &batchv1.JobList{},
		},
		"networking.k8s.io/v1": {
			"IngressClass":  &networkingv1.IngressClassList{},
			"Ingress":       &networkingv1.IngressList{},
			"NetworkPolicy": &networkingv1.NetworkPolicyList{},
		},
		"policy/v1": {
			"PodDisruptionBudget": &policyv1.PodDisruptionBudgetList{},
		},
		"rbac.authorization.k8s.io/v1": {
			"ClusterRoleBinding": &rbacv1.ClusterRoleBindingList{},
			"ClusterRole":        &rbacv1.ClusterRoleList{},
			"RoleBinding":        &rbacv1.RoleBindingList{},
			"Role":               &rbacv1.RoleList{},
		},
		"apps/v1beta1": {
			"Deployment":  &appsv1beta1.DeploymentList{},
			"StatefulSet": &appsv1beta1.StatefulSetList{},
		},
		"apps/v1beta2": {
			"DaemonSet":   &appsv1beta2.DaemonSetList{},
			"Deployment":  &appsv1beta2.DeploymentList{},
			"ReplicaSet":  &appsv1beta2.ReplicaSetList{},
			"StatefulSet": &appsv1beta2.StatefulSet{},
		},
		"batch/v1beta1": {
			"CronJob": &batchv1beta1.CronJobList{},
		},
		"networking.k8s.io/v1beta1": {
			"IngressClass": &networkingv1beta1.IngressClassList{},
			"Ingress":      &networkingv1beta1.IngressList{},
		},
		"policy/v1beta1": {
			"PodDisruptionBudget": &policyv1beta1.PodDisruptionBudgetList{},
		},
		"rbac.authorization.k8s.io/v1alpha1": {
			"ClusterRoleBinding": &rbacv1alpha1.ClusterRoleBindingList{},
			"ClusterRole":        &rbacv1alpha1.ClusterRoleList{},
			"RoleBinding":        &rbacv1alpha1.RoleBindingList{},
			"Role":               &rbacv1alpha1.RoleList{},
		},
		"rbac.authorization.k8s.io/v1beta1": {
			"ClusterRoleBinding": &rbacv1beta1.ClusterRoleBindingList{},
			"ClusterRole":        &rbacv1beta1.ClusterRoleList{},
			"RoleBinding":        &rbacv1beta1.RoleBindingList{},
			"Role":               &rbacv1beta1.RoleList{},
		},
	}

	return supportedKinds
}

func isTarget(target string, targetOptions []string) bool {
	if targetOptions[0] == "*" || utils.Contains(target, targetOptions) {
		return true
	}
	return false
}

func getDestinationFolder(destinationPath string) (string, error) {
	var err error
	if destinationPath == "" {
		destinationPath, err = os.Getwd()
		if err != nil {
			return "", errors.Wrap(err, "failed to get working directory")
		}
	}
	destFolderName := fmt.Sprintf("kics-extract-kuberneter-%s", time.Now().Format("01-02-2006"))
	destination := filepath.Join(destinationPath, destFolderName)

	if err := os.MkdirAll(destination, dirPerms); err != nil {
		return "", err
	}

	return destination, nil
}

func getAPIVersion(apiVersion string) string {
	if apiVersion == "core/v1" {
		return "v1"
	}
	return apiVersion
}

func getSupportedOptions(supportedKinds *supportedKinds) (v, k *[]string) {
	supportedAPIVersions := make([]string, 0)
	supKinds := make([]string, 0)

	for apiVersion := range *supportedKinds {
		supportedAPIVersions = append(supportedAPIVersions, apiVersion)
		for kind := range (*supportedKinds)[apiVersion] {
			supKinds = append(supKinds, kind)
		}
	}

	supportedAPIVersions = append(supportedAPIVersions, "*")
	supKinds = append(supKinds, "*")

	return &supportedAPIVersions, &supKinds
}
