module IconsHelper
  def chevron_up(css_classes = "w-4 h-4")
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class=#{css_classes}>
        <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 15.75 7.5-7.5 7.5 7.5" />
      </svg>
    SVG
    .html_safe
  end

  def chevron_down(css_classes = "w-4 h-4")
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class=#{css_classes}>
        <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
      </svg>
    SVG
    .html_safe
  end

  def chevron_updown(css_classes = "w-4 h-4")
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class=#{css_classes}>
        <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 15 12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9" />
      </svg>
    SVG
    .html_safe
  end

  def chevron_right(css_classes = "h-5 w-5 flex-shrink-0 text-gray-400")
    <<~SVG
      <svg class="#{css_classes}" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
        <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
      </svg>
    SVG
    .html_safe
  end

  def dot(css_classes = "h-0.5 w-0.5 fill-current")
    <<~SVG
      <svg viewBox="0 0 2 2" class="#{css_classes}">
        <circle cx="1" cy="1" r="1" />
      </svg>
    SVG
    .html_safe
  end

  def download_icon(css_classes = nil)
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="#{css_classes}">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5M16.5 12 12 16.5m0 0L7.5 12m4.5 4.5V3" />
      </svg>
    SVG
    .html_safe
  end

  def upload_icon(css_classes = nil)
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="#{css_classes}">
        <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75V16.5m-13.5-9L12 3m0 0 4.5 4.5M12 3v13.5" />
      </svg>
    SVG
    .html_safe
  end

  def run_icon(css_classes = nil)
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="#{css_classes}">
        <path stroke-linecap="round" stroket-linejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.347a1.125 1.125 0 0 1 0 1.972l-11.54 6.347a1.125 1.125 0 0 1-1.667-.986V5.653Z" />
      </svg>
    SVG
    .html_safe
  end

  def trash_icon(css_classes = nil)
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="#{css_classes}">
        <path stroke-linecap="round" stroke-linejoin="round" d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0" />
      </svg>
    SVG
    .html_safe
  end

  def link_icon(css_classes = nil)
    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="#{css_classes}">
        <path d="M12.232 4.232a2.5 2.5 0 0 1 3.536 3.536l-1.225 1.224a.75.75 0 0 0 1.061 1.06l1.224-1.224a4 4 0 0 0-5.656-5.656l-3 3a4 4 0 0 0 .225 5.865.75.75 0 0 0 .977-1.138 2.5 2.5 0 0 1-.142-3.667l3-3Z" />
        <path d="M11.603 7.963a.75.75 0 0 0-.977 1.138 2.5 2.5 0 0 1 .142 3.667l-3 3a2.5 2.5 0 0 1-3.536-3.536l1.225-1.224a.75.75 0 0 0-1.061-1.06l-1.224 1.224a4 4 0 1 0 5.656 5.656l3-3a4 4 0 0 0-.225-5.865Z" />
      </svg>
    SVG
    .html_safe
  end

  def notice_icon(css_classes = "h-6 w-6 text-green-400")
    <<~SVG
      <svg class="#{css_classes}" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    SVG
    .html_safe
  end

  def alert_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495ZM10 5a.75.75 0 0 1 .75.75v3.5a.75.75 0 0 1-1.5 0v-3.5A.75.75 0 0 1 10 5Zm0 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd" />
      </svg>
    SVG
    .html_safe
  end

  def ok_icon(css_classes = "")
    <<~SVG
      <svg class="size-5 text-green-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" data-slot="icon">
        <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z" clip-rule="evenodd" />
      </svg>
    SVG
    .html_safe
  end

  def error_icon(css_classes = "h-6 w-6 text-red-400")
    <<~SVG
      <svg class="#{css_classes}" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
        <path d="M9 9L15 15 M15 9L9 15 M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
      </svg>
    SVG
    .html_safe
  end

  def bell_icon(css_classes = "mx-auto h-12 w-12 text-gray-400")
    <<~SVG
      <svg class="#{css_classes}" stroke="currentColor" fill="none" viewBox="0 0 24 24" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0M3.124 7.5A8.969 8.969 0 0 1 5.292 3m13.416 0a8.969 8.969 0 0 1 2.168 4.5" />
      </svg>
    SVG
    .html_safe
  end

  def plgrid_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" viewBox="0 0 40 41" xmlns="http://www.w3.org/2000/svg">
      <path d="M25 23.3H26.2V32.3H25V23.3ZM23.7 16.9H22.3V13.6H23.7C24.7 13.6 25.1 14 25.1 15.2C25.2 16.5 24.7 16.9 23.7 16.9ZM23.7 12.6H21.1V21.6H22.2V18H23.6C25.3 18 26.2 17.2 26.2 15.3C26.3 13.4 25.5 12.6 23.7 12.6ZM20.4 27.8H19V24.3H20.4C21.4 24.3 21.8 24.7 21.8 25.9C21.8 27.2 21.3 27.8 20.4 27.8ZM21.5 28.6C22.4 28.3 22.9 27.4 22.9 26C22.9 24.1 22 23.3 20.3 23.3H17.7V32.3H18.9V28.8H20.3L22.3 32.3H23.6L21.5 28.6ZM15.7 32.3V26.9H13.4V27.9H14.6V31.2H12.9C11.7 31.2 11.2 30.7 11.2 29.6V25.8C11.2 24.8 11.8 24.2 12.9 24.2H15.8V23.2H12.9C11 23.2 10 24.1 10 25.8V29.6C10 31.3 11 32.2 12.9 32.2H15.7V32.3ZM28.1 12.6V21.6H33.3V20.6H29.3V12.6H28.1ZM32.7 29.7C32.7 30.7 32.1 31.3 31 31.3H29.3V24.4H31C32.2 24.4 32.7 24.9 32.7 26V29.7ZM31 23.3H28.1V32.3H31C32.9 32.3 33.9 31.4 33.9 29.7V25.9C33.9 24.2 32.9 23.3 31 23.3ZM7.99999 19.9L1.79999 19.1L1.89999 21.6H6.19999L7.99999 19.9ZM22.9 10.6H28.9L30.8 8.7L21.2 9L22.9 10.6ZM19.1 19.5V6.6L18.1 3.5L15.3 4.4L17.3 21.3L19.1 19.5ZM20.9 8.4L30.9 8.2V6L20.9 7V8.4ZM37.6 16.8L32.9 17.5L34.7 19.3H37.8L37.6 16.8ZM38.2 22.8L37.9 20.2L35.6 22.4L38.2 22.8ZM36.4 5.5L32.7 5.9V17L37.5 16.3L36.4 5.5ZM38.2 23.3L35.6 22.9V35.4L38.8 29L38.2 23.3ZM16.7 21.5L14.7 4.6L9.89999 6.2V19.5L11.9 21.5H16.7ZM32 34.1H11.8L18.1 36.8L34.6 35.9L32 34.1ZM23 38.9L34.8 39.9V36.4L19.2 37.3L23 38.9ZM1.89999 23.3L1.99999 26.1L8.19999 25.3L6.19999 23.3H1.89999ZM2.09999 28.2L8.19999 31.9V25.9L1.99999 26.6L2.09999 28.2ZM8.19999 6.7L1.39999 8.9L1.79999 18.5L8.19999 19.3V6.7Z" />
      </svg>
    SVG
    .html_safe
  end

  def github_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
        <path fill-rule="evenodd" d="M10 0C4.477 0 0 4.484 0 10.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0110 4.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.203 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.942.359.31.678.921.678 1.856 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0020 10.017C20 4.484 15.522 0 10 0z" clip-rule="evenodd" />
      </svg>
    SVG
    .html_safe
  end

  def hamburger_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" width="20" height="20" viewBox="0 0 20 20" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M10 3C10.8284 3 11.5 3.67157 11.5 4.5C11.5 5.32843 10.8284 6 10 6C9.17157 6 8.5 5.32843 8.5 4.5C8.5 3.67157 9.17157 3 10 3Z" fill="#0F172A"/>
        <path d="M10 8.5C10.8284 8.5 11.5 9.17157 11.5 10C11.5 10.8284 10.8284 11.5 10 11.5C9.17157 11.5 8.5 10.8284 8.5 10C8.5 9.17157 9.17157 8.5 10 8.5Z" fill="#0F172A"/>
        <path d="M11.5 15.5C11.5 14.6716 10.8284 14 10 14C9.17157 14 8.5 14.6716 8.5 15.5C8.5 16.3284 9.17157 17 10 17C10.8284 17 11.5 16.3284 11.5 15.5Z" fill="#0F172A"/>
      </svg>
    SVG
    .html_safe
  end

  def evaluation_created_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" width="17" height="16" viewBox="0 0 17 16" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M8.5 4V8H11.5M14.5 8C14.5 11.3137 11.8137 14 8.5 14C5.18629 14 2.5 11.3137 2.5 8C2.5 4.68629 5.18629 2 8.5 2C11.8137 2 14.5 4.68629 14.5 8Z" stroke="#1D4ED8" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    SVG
    .html_safe
  end

  def evaluation_pending_icon(css_classes = "")
    evaluation_created_icon
  end

  def evaluation_running_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" width="17" height="16" viewBox="0 0 17 16" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M14.5 8C14.5 11.3137 11.8137 14 8.5 14C5.18629 14 2.5 11.3137 2.5 8C2.5 4.68629 5.18629 2 8.5 2C11.8137 2 14.5 4.68629 14.5 8Z" stroke="#4D7C0F" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M11.1066 7.78146C11.2781 7.87671 11.2781 8.12329 11.1066 8.21854L7.37141 10.2937C7.20478 10.3862 7 10.2657 7 10.0751V5.92488C7 5.73426 7.20478 5.61377 7.37141 5.70634L11.1066 7.78146Z" stroke="#4D7C0F" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    SVG
    .html_safe
  end

  def evaluation_completed_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" width="17" height="16" viewBox="0 0 17 16" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M12.916 3.37597C13.2607 3.60573 13.3538 4.07138 13.124 4.41603L8.12404 11.916C7.9994 12.103 7.7975 12.2242 7.5739 12.2464C7.3503 12.2685 7.12855 12.1892 6.96967 12.0303L3.96967 9.03033C3.67678 8.73744 3.67678 8.26257 3.96967 7.96967C4.26256 7.67678 4.73744 7.67678 5.03033 7.96967L7.38343 10.3228L11.876 3.58398C12.1057 3.23933 12.5714 3.1462 12.916 3.37597Z" fill="#15803D"/>
      </svg>
    SVG
    .html_safe
  end

  def evaluation_failed_icon(css_classes = "")
    <<~SVG
      <svg class="#{css_classes}" width="17" height="16" viewBox="0 0 17 16" fill="none" stroke="currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M8.49985 6.00004V8.50004M2.29768 10.7505C1.72076 11.7505 2.44248 13 3.59696 13H13.4027C14.5572 13 15.2789 11.7505 14.702 10.7505L9.79913 2.25213C9.22188 1.25157 7.77781 1.25157 7.20057 2.25213L2.29768 10.7505ZM8.49985 10.5H8.50485V10.505H8.49985V10.5Z" stroke="#BE123C" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    SVG
    .html_safe
  end
end
