terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = "https://10.10.0.5:6443"
  client_certificate     = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJQlhwa2hFQjcyYTB3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpFeU1EZ3hPVEF5TWpWYUZ3MHlNekV5TURneE9UQXlNamhhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTVOcUR5RzRyV0w5ZW9MMW8KQUtZSTFoY28vNW9OOFA2TXIyRDRtTlJWbnh3K3lkRlRqLzFYejduL0N0Q1pYNmI1OEIveVNzWkNiTERxNHdpTQpGeWlRSmorZy9kdWlHekxRSlRkUHNaN3NRNFpiL2d1cHVOaUhJY0dQVXk2UXYzc3VmMU55TWpWWWNRcVA4aDhPCjBUUVNFdEhQYllIS3A5dzB4VjFOMEM3YXNTNXBYdDdJWWRDOCs5cit3UVZYT3dVa1JSM2lSSG1mOTRDZDQzc0gKeURwakZIbDdqRkZkV1pFN3VRS29jcU1UOXVWcEV1ZzhKdVFPaDNRWEVLWkFEZkpzUldENnpTK3NoN1ZzYXF5QwpBdUxUeWFUWGdlQng1bkZadkFPSk9PbjdubHFNTWhPTHZETmMvYnQvY1VEcUl1L0VkQXZnRFNWYlR6NllsVm1HCjdvYVBrd0lEQVFBQm8xWXdWREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JTbTBDNDd5UWRTKzRDK3ZRWktEZmlLamNPLwpxREFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBWUV6ZEpXMkVQcVJkWE1kb0VYSlVjb2JLdHRtSDMxamljdy9oCkFBSmN1a0IxcmxtelhUN1lEeXVYamRlNDZpbDZpM2d6aVM3VG50aTM5cUtHQ0ExN0RSdVV0aVhLV2psZGZrbysKWElZaHZ6MGd2TW0zbEl2SzdOQ1paMWk3b3Y4aXNXUTRGcC9WaXYzQ3hlQWZUMUtrZ1FXaGRLTnhaeGF6TVhFTgprSko4VmhUNzJqZGVPMXVMM2lKd0pzWmUvcCtkeFlzcG9CUUdDcU1IUjBvQ21LUFdTQUZKQTdOUmFMSWlnajJ6CmxyYmkyb3owOERMTUZ3R2JVVExrdXNuRFlpMnJ4cFdRa05vNnV0dkRKL1NhaXR3akYvK3NMR2lTc0tnMXdLVGsKL21jdEM5aWZVeHhIT0plL0JpNkV4QnVhaXMrc0VBVVE1OWFXbTRTOVBMVFBmWjhJWkE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
  client_key             = base64decode("LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBNU5xRHlHNHJXTDllb0wxb0FLWUkxaGNvLzVvTjhQNk1yMkQ0bU5SVm54dyt5ZEZUCmovMVh6N24vQ3RDWlg2YjU4Qi95U3NaQ2JMRHE0d2lNRnlpUUpqK2cvZHVpR3pMUUpUZFBzWjdzUTRaYi9ndXAKdU5pSEljR1BVeTZRdjNzdWYxTnlNalZZY1FxUDhoOE8wVFFTRXRIUGJZSEtwOXcweFYxTjBDN2FzUzVwWHQ3SQpZZEM4KzlyK3dRVlhPd1VrUlIzaVJIbWY5NENkNDNzSHlEcGpGSGw3akZGZFdaRTd1UUtvY3FNVDl1VnBFdWc4Ckp1UU9oM1FYRUtaQURmSnNSV0Q2elMrc2g3VnNhcXlDQXVMVHlhVFhnZUJ4NW5GWnZBT0pPT243bmxxTU1oT0wKdkROYy9idC9jVURxSXUvRWRBdmdEU1ZiVHo2WWxWbUc3b2FQa3dJREFRQUJBb0lCQUFNVGtPdnoxeTlWT3o5cgo3R2I5MUdhVVh4KzRnWEY0Nm9rOUEzcUNlRGd3V0FPOGhhUU00czVQRU1lamNEeGg4VUF5SGI2MWxaVUNkOVhmCmVvcWhKL2JycWcxZmszbE1JSkl2Z1NuQkdpbjZOMmhkM2NVM1cvR3ZPVzhEMUR4T3VweEprZUpzNXloMTNPT0QKV1Y2a2xZMmRObTJoYmdqOW85UDNZaUZuVDlkTDR1bEN4T1VVc2wwWE9HUi84OVBKOUd2NWVzOTgrZWhNTmQvQQpRMjkxVk9lUWwyMDB6czNlaDJDNnZnbUVSTTBHNTRRN2haVGhPSERNVjAwc2Q0b2kvTzVXcm5LU3FRTVczcWk3CjVJNDBhRy9HZjdxc0NKemRjZU1xM2FkQ2pxQTZmYU53VXVIbDhlb2w2TXhlTXFmKzdUVUVoTWFJYmkvWHVya3IKU3RReXVMa0NnWUVBL0pkNEdaQWtkMXVxdmQvcnhOVkpUZHVhN1MzU3laQk4vN2xuNkRGVUZkdHcwMFBhMGRRYQpWb2NBT2lyOUMxOWVnMkgzRytjVDJLTWxreXBkR1pxbWJyK3ZpV2JRWk4wREo1d3dUemUvRVMyMmZGc2hXM2ZKCnA0QmgzQk1LVmhsVy9jYVJtSUpSeFdjZ0M3cWE0YXg1Vkl6SVRKbnNjL25udlByV1hKb2ViSFVDZ1lFQTUvRUwKK2g5Z1RUNFgvclZwclRTd2Nab1JIT2c0bDlsY2FVcEovUmRuTnBaMHdWVGp6TFJ4QXd6SHpUbFNRU3M2QnNjRAp4dXpENmNFMXlYMHAyZHBNalVPTnc0OVAvL2R4aXZPRTFPaC9yL1Z5dHFKUHRwSVd4UEZRcUN2cUkvdlRwa1NVCnZwRWE0L3ZIb3JUbi9NaUc4Ty9GTy9pSnhCZ05MVWtsVHhjNXF1Y0NnWUFFNlFUaXFsU3JKVk1LWWVINWI1UC8KT1hlbmlLNkNVSlhUbE0wYVRHc3dDWllGNVZuSm5tL3NvcTgwY2tWOUJSdVhQajVKZ3BKMk1hVzNXS2w2cC9ENApVaTJkWkN4RTZhNzRCQ2RFUXZjcDVGT1owME93dllGa0NqRGMwRm54Rm9rRVllbk9weW5qeG45dSt1K3IxMmg4ClprZzJoUDk5dWF2eGxvYTRRaDY1U1FLQmdRQ0dMSk5aSmoxM2Nhdy8xSUpGaUcxcHlrNk1BbXA2cldzZ0hiR2YKajZKTm1jd0E2eks4Z01XL2xlMGZjMEY2SVo5M3ZEa2JJbXhURlVvZ1BSK3d2dS81NkZKaUJzMm9yV1FwbGFZSgo1Rlc1WEt2M3F2MmlCL0RVRFNVem8vUFd6UjhxMkJHVURDMGFKZFRlOHZnZzYzL2tjVkFQMlQ4WkNURFdPYkl6CmhxUDlrUUtCZ0RWTjlLTEMya3RVK2FLV1kyVzVrd1Fqb2lQZFI0dXdFQzcyOTdlTzJYckJsWVNGZ0hSaFgxZ1IKTzZicHRMSEM5NXRvbWdyWS82RFNNcHBiaWRHSmtvNlFnVzR5cGVCRlRZeEh4b0hQS05MVDVaNGQxeU5YOGUwWApQQnAwSFdEejBoRnZDbVUwMGUzK2MxcGxXUXl5RnZ3VlVVUGVHRXB1RmJFdWNHUUt4WXRECi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==")
  cluster_ca_certificate = base64decode("LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1USXdPREU1TURJeU5Wb1hEVE15TVRJd05URTVNREl5TlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTHBkClZWa0xabmtJNmI5aGMxLzNrQnJuRzNvZlJNM1NKMk9mVFhMTTdMKzI0emVHcThRVk1KMHRDb1ZOSzBMbDMxVXIKOVBuQzhGZEdTYnhzYzlPa0k0U2lpTk9RcWpBZ2pXWnlQYzBmNU14cmE2UlE5Vk5mYlk3NE5lU29hUjdVTG81Vwp4QUs5Y0dITWp6Sk9BbzMyVm9CeFUwQWlWQjVoTHZFaVBuTUhlNlVRb3I4NUI3NWFZV0hkRDJ6ODJ4Y2VjVjdUCm9ZeVVKbUM5a2tOZm9XcktUZEJweGtVVWpVMDRjeThNcURNc3duYUlIQ3JjMm5QMmx6eU1wTmVONXE1T2hlLy8KQ1JYRnpyejQxM09HWUlNYnp2MnlKeTNvSTFtcXVOcm1od1lTZVlDNVhoTVhmZW5zM0I3TmtYZEdCUzQ5MGdQTgp5ZzFKTWozMDZyNzRHMEdpQUNNQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZLYlFManZKQjFMN2dMNjlCa29OK0lxTnc3K29NQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBS1NoTE04QmhUVDZ3dUU3N01hcQppU25Vb0g3ckFwNnBhMWlpcHFQR2hYeXFmZFFtdWMrSlMvcHFYRFczNExOUFNjVGl1MGVxRlBTQ2Y0SllFeG1zClkza2REU1Jla3MrQTBHTUhTVWd5b0h2RXlsbXNVNlQxT2VZMFA5UW9kRmFqdVRCRFh1SlZEVi9QcHVmZDVkL1EKUlpKZnV2ZDlhTWQ1dlJFbGZoNTdFRmc3T0dRSEFZVkhOeUozZ25jNXVzcXRxQ1NBZTJCZEZNdmNycG1xTTJHRQpBK3BjRzMzN3FEWjR4S0JidXU1QkJUUERXRWF2eTRQUnRuWkQ0K0lqRldqbVJQQm4vazg1c0ZWcS9qNUY0QTVVCnZScnNSdlpTWWdEOE1HNFg2WUxwKyt6RDRobmxWZDdxMDlsRnovbUdBU3hNRFIyRWE0MVZ0WEdMQ2h5TnpJMFkKSmZZPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==")
}