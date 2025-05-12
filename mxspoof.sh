#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# ASCII Art Header for MXSpoof
print_banner() {
cat << "EOF"

 /$$      /$$ /$$   /$$  /$$$$$$                                 /$$$$$$ 
| $$$    /$$$| $$  / $$ /$$__  $$                               /$$__  $$
| $$$$  /$$$$|  $$/ $$/| $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$ | $$  \__/
| $$ $$/$$ $$ \  $$$$/ |  $$$$$$  /$$__  $$ /$$__  $$ /$$__  $$| $$$$    
| $$  $$$| $$  >$$  $$  \____  $$| $$  \ $$| $$  \ $$| $$  \ $$| $$_/    
| $$\  $ | $$ /$$/\  $$ /$$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$      
| $$ \/  | $$| $$  \ $$|  $$$$$$/| $$$$$$$/|  $$$$$$/|  $$$$$$/| $$      
|__/     |__/|__/  |__/ \______/ | $$____/  \______/  \______/ |__/      
                                 | $$                                    
                                 | $$                                    
                                 |__/                                    
                              
MXSpoof - Email Spoofing Detector - by TomSec8

EOF
}

print_explanation() {
  echo -e "\n📘 Explanation of Parameters:"
  echo -e "🔐 SPF   - Defines which servers can send mail on behalf of the domain."
  echo -e "🔐 DKIM  - Cryptographically signs mail to verify authenticity."
  echo -e "🔐 DMARC - Policy to enforce SPF/DKIM validation and tell servers what to do when validation fails."
  echo ""
}

save_results() {
  read -p $'\n💾 Do you want to save the results? [y/N]: ' save_choice
  if [[ "$save_choice" =~ ^[Yy]$ ]]; then
    if [[ "$mode" == "single" ]]; then
      output_file="${domain//\//_}_spoofcheck.txt"
    else
      output_file="spoofcheck_list_results.txt"
    fi
    echo -e "$output_log" > "$output_file"
    echo -e "${GREEN}✅ Results saved to: $output_file${NC}"
  fi
}

check_domain() {
  local domain=$1
  root_domain=$(echo "$domain" | sed -E 's@^(www\.)?([^/]+).*@\2@' | awk -F. '{n=NF-1; print $(n)"."$(n+1)}')

  echo -e "\n📡 Spoofability Check for: ${BLUE}$domain${NC}" | tee -a temp_output.txt
  echo "----------------------------------------" | tee -a temp_output.txt

  if ! dig +short "$domain" | grep -q .; then
      echo -e "${RED}❌ Domain not resolvable. Skipping.${NC}" | tee -a temp_output.txt
      return
  fi

  spf_record=$(dig +short TXT "$root_domain" | grep -i "v=spf1")
  if [[ -z "$spf_record" ]]; then
      echo -e "🔐 SPF: ${RED}❌ No SPF record found${NC}" | tee -a temp_output.txt
      spf_score=0
  elif [[ "$spf_record" == *"-all"* ]]; then
      echo -e "🔐 SPF: ${GREEN}✅ Strict (-all)${NC}" | tee -a temp_output.txt
      spf_score=3
  elif [[ "$spf_record" == *"~all"* || "$spf_record" == *"?all"* ]]; then
      echo -e "🔐 SPF: ${YELLOW}⚠️ Soft or Neutral (~all / ?all)${NC}" | tee -a temp_output.txt
      spf_score=1
  elif [[ "$spf_record" == *"+all"* ]]; then
      echo -e "🔐 SPF: ${RED}❌ Permissive (+all) — Vulnerable${NC}" | tee -a temp_output.txt
      spf_score=0
  else
      echo -e "🔐 SPF: ${YELLOW}⚠️ Unclear configuration${NC}" | tee -a temp_output.txt
      spf_score=1
  fi

  dmarc_record=$(dig +short TXT "_dmarc.$root_domain" | grep -i "v=DMARC1")
  if [[ -z "$dmarc_record" ]]; then
      echo -e "🔐 DMARC: ${RED}❌ No DMARC record found${NC}" | tee -a temp_output.txt
      dmarc_score=0
  elif [[ "$dmarc_record" == *"p=none"* ]]; then
      echo -e "🔐 DMARC: ${YELLOW}⚠️ Policy = none (monitor only)${NC}" | tee -a temp_output.txt
      dmarc_score=1
  elif [[ "$dmarc_record" == *"p=quarantine"* ]]; then
      echo -e "🔐 DMARC: ${YELLOW}⚠️ Policy = quarantine${NC}" | tee -a temp_output.txt
      dmarc_score=2
  elif [[ "$dmarc_record" == *"p=reject"* ]]; then
      echo -e "🔐 DMARC: ${GREEN}✅ Policy = reject (strict enforcement)${NC}" | tee -a temp_output.txt
      dmarc_score=3
  else
      echo -e "🔐 DMARC: ${YELLOW}⚠️ Record unclear${NC}" | tee -a temp_output.txt
      dmarc_score=1
  fi

  dkim_score=0
  found_dkim=0
  selectors=(default google mail selector1 selector2 dkim smtp)

  for sel in "${selectors[@]}"; do
      dkim_record=$(dig +short TXT "$sel._domainkey.$domain" | grep -i "v=DKIM1")
      if [[ -n "$dkim_record" ]]; then
          echo -e "🔐 DKIM: ${GREEN}✅ Found (selector: $sel)${NC}" | tee -a temp_output.txt
          found_dkim=1
          dkim_score=2
          break
      fi
  done

  if [[ "$found_dkim" -eq 0 ]]; then
      echo -e "🔐 DKIM: ${RED}❌ Not detected (common selectors tried)${NC}" | tee -a temp_output.txt
  fi

  total_score=$((spf_score + dmarc_score + dkim_score))
  echo -e "\n📊 Spoofability Score: $total_score / 8" | tee -a temp_output.txt

  if [[ "$total_score" -le 2 ]]; then
      echo -e "${RED}❗ This domain is highly spoofable!${NC}" | tee -a temp_output.txt
  elif [[ "$total_score" -le 4 ]]; then
      echo -e "${YELLOW}⚠️ This domain has weak spoofing protection.${NC}" | tee -a temp_output.txt
  else
      echo -e "${GREEN}✅ This domain is reasonably protected against spoofing.${NC}" | tee -a temp_output.txt
  fi
}

while true; do
  clear
  print_banner
  echo -e "${BLUE}==== Email Spoofability Checker ====${NC}"
  echo "1) Check a single domain"
  echo "2) Check multiple domains from file"
  echo "3) Exit"
  echo "------------------------------------"
  read -p "Choose option [1, 2, or 3]: " option

  print_explanation
  output_log=""
  rm -f temp_output.txt

  if [[ "$option" == "1" ]]; then
      mode="single"
      read -p "Enter a domain to check: " domain
      check_domain "$domain"
      output_log=$(cat temp_output.txt)
      save_results
  elif [[ "$option" == "2" ]]; then
      mode="list"
      read -p "Enter path to file with domains: " filepath
      if [[ ! -f "$filepath" ]]; then
          echo -e "${RED}File not found: $filepath${NC}"
          read -p "Press Enter to continue..."
          continue
      fi
      while read -r domain; do
          [[ -z "$domain" ]] && continue
          check_domain "$domain"
      done < "$filepath"
      output_log=$(cat temp_output.txt)
      save_results
  elif [[ "$option" == "3" ]]; then
      echo -e "${BLUE}Goodbye!${NC}"
      exit 0
  else
      echo -e "${RED}Invalid option.${NC}"
      read -p "Press Enter to continue..."
  fi
  read -p $'\n🔁 Press Enter to return to main menu...'
done
