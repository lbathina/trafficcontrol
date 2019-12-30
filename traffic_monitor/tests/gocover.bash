#!/usr/bin/env bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#----------------------------------------
set -e

coverage_out=()
i=1

for d in $(go list ./... ../lib/... | grep -v vendor); do
	file="$i.out"
	go test -v -coverprofile="$file" "$d"
	if [ -f "$file" ]; then
		coverage_out+=($file)
	fi
	((i++))
done

gocovmerge ${coverage_out[*]} > coverage.out
go tool cover -func=coverage.out
go-junit-report --package-name=golang.test.tm --set-exit-code > /junit/golang.test.tm.xml
touch coverage_out1
for pkg in $(go list ./... ../lib/... | grep -v ); do
	tmp="$(mktemp)"
	go test -v -coverprofile covProfile "$pkg" > "$tmp"
	mv -f "$tmp" coverage_out1
done