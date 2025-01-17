# encoding: utf-8
# frozen_string_literal: true

module TMDb
  module Web
    class Translations

      DEFAULT_MAPPING = {
        'af' => 'af-ZA',
        'ar' => 'ar-SA',
        'be' => 'be-BY',
        'bg' => 'bg-BG',
        'bn' => 'bn-BD',
        'ca' => 'ca-ES',
        'ch' => 'ch-GU',
        'cn' => 'cn-CN',
        'cs' => 'cs-CZ',
        'cy' => 'cy-GB',
        'da' => 'da-DK',
        'de' => 'de-DE',
        'el' => 'el-GR',
        'en' => 'en-US',
        'eo' => 'eo-EO',
        'es' => 'es-ES',
        'et' => 'et-EE',
        'eu' => 'eu-ES',
        'fa' => 'fa-IR',
        'fi' => 'fi-FI',
        'fr' => 'fr-FR',
        'ga' => 'ga-IE',
        'gd' => 'gd-GB',
        'gl' => 'gl-ES',
        'he' => 'he-IL',
        'hi' => 'hi-IN',
        'hr' => 'hr-HR',
        'hu' => 'hu-HU',
        'id' => 'id-ID',
        'it' => 'it-IT',
        'ja' => 'ja-JP',
        'ka' => 'ka-GE',
        'kk' => 'kk-KZ',
        'kn' => 'kn-IN',
        'ko' => 'ko-KR',
        'ky' => 'ky-KG',
        'lt' => 'lt-LT',
        'lv' => 'lv-LV',
        'ml' => 'ml-IN',
        'mr' => 'mr-IN',
        'ms' => 'ms-MY',
        'nb' => 'nb-NO',
        'nl' => 'nl-NL',
        'no' => 'no-NO',
        'pa' => 'pa-IN',
        'pl' => 'pl-PL',
        'pt' => 'pt-PT',
        'ro' => 'ro-RO',
        'ru' => 'ru-RU',
        'si' => 'si-LK',
        'sk' => 'sk-SK',
        'sl' => 'sl-SI',
        'sq' => 'sq-AL',
        'sr' => 'sr-RS',
        'sv' => 'sv-SE',
        'ta' => 'ta-IN',
        'te' => 'te-IN',
        'tl' => 'tl-PH',
        'th' => 'th-TH',
        'tr' => 'tr-TR',
        'uk' => 'uk-UA',
        'vi' => 'vi-VN',
        'zh' => 'zh-CN',
        'zu' => 'zu-ZA'
      }.freeze

      IGNORED_TRANSLATIONS = [
        'en-AU',
        'en-CA',
        'en-GB',
        'en-IE',
        'en-NZ'
      ].freeze

      # This list is based on LANGUAGE_CODES, it contains all assigned ISO-369-1
      # codes, some deprecated codes and the unused xx code as "no-value".
      # https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
      LANGUAGE_CODES = %w[
        aa ab ae af ak am an ar as av ay az ba be bg bi bm bn bo br bs ca ce ch cn co cr cs cu
        cv cy da de dv dz ee el en eo es et eu fa ff fi fj fo fr fy ga gd gl gn gu gv ha he hi
        ho hr ht hu hy hz ia id ie ig ii ik io is it iu ja jv ka kg ki kj kk kl km kn ko kr ks
        ku kv kw ky la lb lg li ln lo lt lu lv mg mh mi mk ml mn mo mr ms mt my na nb nd ne ng
        nl nn no nr nv ny oc oj om or os pa pi pl ps pt qu rm rn ro ru rw sa sc sd se sg sh si
        sk sl sm sn so sq sr ss st su sv sw ta te tg th ti tk tl tn to tr ts tt tw ty ug uk ur
        uz ve vi vo wa wo xh xx yi yo za zh zu
      ].freeze

      def self.country_path
        File.dirname(__FILE__) + "/../../../../countries"
      end

      def self.default_iso_3166_1_mapping
        @default_iso_3166_1_mapping ||= TMDb::Web::Translations::DEFAULT_MAPPING.invert.merge!(
          'ar-AE' => 'ar',
          'de-AT' => 'de',
          'de-CH' => 'de',
          'en-AU' => 'en',
          'en-CA' => 'en',
          'en-GB' => 'en',
          'en-IE' => 'en',
          'en-NZ' => 'en',
          'es-MX' => 'es',
          'fr-CA' => 'fr',
          'ms-SG' => 'ms',
          'nl-BE' => 'nl',
          'pt-BR' => 'pt',
          'zh-HK' => 'zh',
          'zh-SG' => 'zh',
          'zh-TW' => 'zh'
        ).freeze
      end

      def self.default_iso_3166_1_mapping_lowercase
        @default_iso_3166_1_mapping_lowercase ||= TMDb::Web::Translations.default_iso_3166_1_mapping.each_with_object({}) do |(i18n, iso_3166_1), hash|
          hash[i18n.downcase] = i18n
        end.freeze
      end

      def self.valid_i18n_translations
        @valid_i18n_translations ||= TMDb::Web::Translations.language_list.dup.delete_if { |k,v| TMDb::Web::Translations::IGNORED_TRANSLATIONS.include?(k) }.freeze
      end

      def self.default_iso_3166_1_i18n
        @default_iso_3166_1_i18n ||= TMDb::Web::Translations.language_list.each_with_object({}) do |(i18n, iso_3166_1), hash|
          iso_3166_1 = i18n.split('-')[1]
          hash[iso_3166_1] = i18n unless hash[iso_3166_1]
        end.freeze
      end

      def self.default_language_i18n
        @default_language_i18n ||= LANGUAGE_CODES.each_with_object({}) { |iso_639_1, hash|
          hash[iso_639_1] = "#{iso_639_1}-#{iso_639_1.upcase}"
        }.merge!(TMDb::Web::Translations::DEFAULT_MAPPING).freeze
      end

      def self.default_language_to_country_mapping
        @default_language_to_country_mapping ||= Hash[TMDb::Web::Translations::DEFAULT_MAPPING.map { |k,v| v.split('-') }].freeze
      end

      def self.language_list
        @language_list ||= (LANGUAGE_CODES - TMDb::Web::Translations.supported_iso_639_1).each_with_object({}) do |iso_639_1, hash|
          hash["#{iso_639_1}-#{iso_639_1.upcase}"] = "#{iso_639_1}"
        end.merge!(TMDb::Web::Translations.default_iso_3166_1_mapping).sort_by { |h,v| v }.to_h.freeze
      end

      def self.language_path
        File.dirname(__FILE__) + "/../../../../languages"
      end

      def self.load_path
        File.dirname(__FILE__) + "/../../../../locales"
      end

      def self.parse_valid_i18n(string)
        return ['en-US', 'en', 'US'] if (string.nil? || string == '')

        begin
          language, region = string.split('-')
          if (region = region&.upcase)
            ["#{language}-#{region}", language, region]
          else
            ["#{language}-#{language.upcase}", language, language.upcase]
          end
        rescue
          ['en-US', 'en', 'US']
        end
      end

      def self.supported_iso_639_1
        TMDb::Web::Translations::DEFAULT_MAPPING.keys
      end

      def self.supported_iso_639_1_path
        @supported_iso_639_1_path ||= TMDb::Web::Translations.supported_iso_639_1.map { |iso| "/#{iso}" }.freeze
      end

      def self.transliteration_path
        File.dirname(__FILE__) + "/../../../../transliteration"
      end

    end
  end
end
