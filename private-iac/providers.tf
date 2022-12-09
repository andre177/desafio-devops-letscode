terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "kubernetes" {
  #TODO: get credentials from secrets manager
  host                   = "https://10.10.0.28:6443"
  client_certificate     = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJZlZHYURXdU9yZzh3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpFeU1Ea3dNalUxTlRaYUZ3MHlNekV5TURrd01qVTJNREJhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXNRdEtmRmRqUVdiSEE4QloKdjVGakpjbUhxSTRmNVBLSXRKMytFQzY5Q0tyOFBud2Ftd0NqdlR3U3g4TFFaVlIvcTk4ZFdXM3dDQWZSQWpaRQpwQnhrREpWMHNkaUdyaDFpMlJuRVYyUzJUd0VBalJ1cjdPaWZsM0ZqZVBuTURyRjcxZHZHTldJQkNVWS9POFUvCmx1cGRjWnVaejBiem1QVEFTS2hCbGx5R25aOS9YNXFEM2ZDaE9USkhJZVlKM2xvbUEzWUJERXR1TlZ0ZlRwUWgKaFlwNjYzRXQrWnlrS09CcWtaSzgxMllnSUpSVVU0N1djdDl0aC9RZk1BeWlrNURLTWZlUjE5ZGs0SnZvaDVNdApIR1JtVnh3amkzYm9udWZDZjhGZkRhbXh2UFg2aGpkSTR0aXFXcE1IR3FpeFlySFdpVi9GNno3Smg4QTBsR0xoClBZZTlIUUlEQVFBQm8xWXdWREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JTd2JreVRsN3NCOUNTQjlPeVdlRVplNmJ0cgo0VEFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBcksyLzdrMGJsNzA2d2toeGFmSWFlN29kcWgzNmZydnlhZzJZCkI4SHJyK1hQT01aSi9qeG5RVWpua0kzeE5UNTVvdVVYY0JrZGliaEViM1dIMnE5Y0crN0tzeHVtYmdhV2ZHVTEKNXh1Vm5rVnBuaE5WZFdqKys4MGtmVkgxaXh3MTdiYURGYkNmMWVEVXlQd1Z1Y1lvNVRhM05QZ0FvWEt3REt0aQpjQXVEdzYwTjFkV0NtbjI3d2hCVTNyKzNlMGZoUlNGSlJ3SnUrMHZITG10WFVsTGZQNXloRFBlNTBnNktGRExpCkZ4YjNBR3NXY1p4QXNJZkdBemtLNXp0ckNON0pnbzcwSWpyQVVhdy8yWjJOc1RUN3ZsU3ZJNFAxSHFYWldibG8KdFBnYUxiNk9PdEszeStJWFljelVCZ1pBaGw4a0U2UUQ0bVdqWThaZU1iS2krTVduZ1E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  client_key             = base64decode("LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBc1F0S2ZGZGpRV2JIQThCWnY1RmpKY21IcUk0ZjVQS0l0SjMrRUM2OUNLcjhQbndhCm13Q2p2VHdTeDhMUVpWUi9xOThkV1czd0NBZlJBalpFcEJ4a0RKVjBzZGlHcmgxaTJSbkVWMlMyVHdFQWpSdXIKN09pZmwzRmplUG5NRHJGNzFkdkdOV0lCQ1VZL084VS9sdXBkY1p1WnowYnptUFRBU0toQmxseUduWjkvWDVxRAozZkNoT1RKSEllWUozbG9tQTNZQkRFdHVOVnRmVHBRaGhZcDY2M0V0K1p5a0tPQnFrWks4MTJZZ0lKUlVVNDdXCmN0OXRoL1FmTUF5aWs1REtNZmVSMTlkazRKdm9oNU10SEdSbVZ4d2ppM2JvbnVmQ2Y4RmZEYW14dlBYNmhqZEkKNHRpcVdwTUhHcWl4WXJIV2lWL0Y2ejdKaDhBMGxHTGhQWWU5SFFJREFRQUJBb0lCQUZXdWRqVHBBZk16NzFyawphMHJuN01qcjJJaDloL2dBWEtLMDE3RXpQVzhGZVNBd1padmdXbDRKeGJrQmttT0gybVh1aThDdEVQNkI4ZWdWCkpYRWJBRnlLdERnaDUwUTZtbzBoQ0VHWFR4ZTdEMjQ3RnlDSGtEejF0a05rK1JtZlVhUTFRWjZ5T0hncGxBNjAKTGtzMlQxVGREam9mUjJNZUNEVGhvU1JJMFNsVXFkeC9qOFRFaW5SYmNDOU9pSDlVVERTRmpBN3BydGJQY3Z3WQpBc0syK1hNK21LZ0ZST0xZSmJBOEFkQXlOWmt3MVZKbUxaMVU5Kzd4TkFlaXlUMDVLUFM5bDZBdUVNYk02YUdhCjNXUnhXNXlkamhEcTZpMHl1MzJEaW5uVEFUMWxXSHpWN2dUQWJsQXc2Z2ZFbVBmejQ4b1JKRXhJR0cyT3c1WUQKQ2w0QzRzRUNnWUVBNWdoNWgzRzNqcE1DSzVwazFwdWVMSXllbFB0Ym82a0NCYVlFeGJYdXJ1czhKckJGMW4zNQpnQ3lkb1pTbUUzejh5QVJJM3owbC8wazZlc0hSNFFjMnl0NC9vUk82bytsUXRNUC91QWlsRUg4dFBqMVJsNnhGCmhTbjFnWVQ3NHdBRUlZSzE2TjErTlVuN05LYm42eDRxQWs3Sk1nZW5WNmhTajNtdE5sR3R5bEVDZ1lFQXhRZUkKbG84clpld2t1UGF5eEtiT0R1RUo1VmZRUmtNcjZ3Y1hrSHFjYXNOYlM3SE1xNmRrQklqVVFXMjgrZEEzRlRidApEUnlKYzhROXFIV2g2TWg4K2krMUtUWUl4d2RYbUtzUEtNckNpZ3FVYXdsQnRlZFp4dmx6a0lXYm9WdUd5Q0tOCmQ1bVl4cUVScGxRWGpWSFZWeS8zZ1FQRTNXVDV6N2NIOWQwWVJ3MENnWUVBenZWaStiUWJGSUE1SEtlOC84UmsKeStuOEowZjZpOFZiMTE4bHZnZlFaYm1vbFpwVVN3VnQrNTZvZDU1NHlPSFR2OVR6Qno1SnVHUFc1R2tLL2kxeQpZNVVQcEVsT3kzZjNyNXNEc0R5KzNaZStTZGY3VjcyYmtwSk1tcW5kd2I3YStKZFVPTjFHVm9Wb0tGZmVJcEF4CjlYK1N6cHRLT0xodEJ6N08weWNyZC9FQ2dZQWYzNm9mQVNZNkpNdUVDSlMrNzJVaVR4RjB3cEgwNitUczdvYkgKWHE1ekx3dFQ0WDJFdjEyVXhqWGdKOHFNZHp5UitBSzlQa0tXTWNidnU2Zm5xcGRkT2Q2S3ZpMEpWWXk4SytBVgo3MGN0WWF6RTdBaHZUdS9kR25teGhZdTV2TDYvSGFmWkUwWDl6QXk0NVoyeHhPMUlYNEFncE9WeUUyVytUcFBCCkdIVlcrUUtCZ0RURlZSQUQ3RElnUGJjdkRiMFF3UGlyTDNPa0N3YXJ1RGI0MHdnM0VscG42WjlodEFSa3ZBZm4KdnE5OEhGNUFUWUJGK1pXS1JOOVkzZWVta09WdDlzVXU5c2hCVE9aNXUxdmRSamJYOVVoaUVYaGxHc2JDYjZOYwpZYmFsTFNMRG1ORUt2aHpKZ3BCL3pmSUZGbndlQ1FjdlA2dzJQb1IydXpwbUJDNDFVSXJPCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==")
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1USXdPVEF5TlRVMU5sb1hEVE15TVRJd05qQXlOVFUxTmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTEN1CjRvTXBYbWxyRU1BVmlYREFPenFyNWdTVnR3d25NSzVpZUl0VG9DQlZiN0NZNHp3SG9wK2o1aTdZdVEwSGZKREcKc25SSnVtZDlPWS9YTjR4NWZpZjFHK3VoVDZMUUpQSVQraWw0RzUybWZtbnhzcTdXZFZGemVZN010T1M5WVplNQp3LzhpOVRlc3QrM0FkUDFhaGdhK1QyT3pRdjBidjBJajZ6aVBwVDdQM1B1ZTEyN3ZleHNjZ096Ykx3N21WbUFoClFtZVZOMWZ0VUpqeWRLYko5SjNBZmlFaUFUWVlMUVlIdGpKMXVUSnFzMVJuNGEzNGlGbDk5aDlNSkt5Y0h5ck0KaTJ6azJKWU83aE9GUHVkUzY1aWF3KzNKdVl3eld0ZlpOOVZLYW5JTjBMYW5DNUt6amxkRFEzd211SGI2TTE1Vwp3bHFTa1VSM3RVRlVWeVFuSGRzQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMQnVUSk9YdXdIMEpJSDA3Slo0Umw3cHUydmhNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRXIySGt6MFFnWmFJcDVDUG9GNgpkWlFCRWhnK3NncVZyMXZEbnF0VVJjNXJUc0kvak9ock5FUGp3OStCTDR0MDczTnFhZ0FPNG5RbWlEcC9TaG5sCmZjNldLdlFVb09HUVV3cVhHaWJjMGMvVDV2Q3Vlc2h3Mmp4N0kxOGNzQnJvQ3pidWtKbUo0UGhWdkpudlV0VVgKLzhxeGFpZUV4MSt3eTFsK1VhSjl6a2g5ZDBXQ3FpL1Nxa0M4aXI1Y1BJNHk2UDNoV1JwUlVKdEJ3Tk0renBPeApOeWpXaGJ4YkhwWmFGaEFLZWFzb2JGREtpUjNvd21mVmVXMzBIL2dpRitTTlNHRDF0WkZHYXN5RlBzeUt5M21hClE3Qnlsb3Q1N3NiSmpTZldMZm1SY3M0eVRpVzUrSEx3dFl4UzdKUHh1OUxxUTBsOWZtMmJEb1ZxY2JsWEhHRXkKM0swPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
}