require 'prawn'
require 'printing_machine/config'
require 'printing_machine/generator'
require 'printing_machine/document'
require 'printing_machine/transformations'
require 'printing_machine/field/base_field'
require 'printing_machine/field/text_box'
require 'printing_machine/field/text_field'
require 'printing_machine/field/labeled_text'
require 'printing_machine/field/barcode'
require 'printing_machine/field/rectangle'
require 'printing_machine/field/table'
require 'printing_machine/command/base_command'
require 'printing_machine/command/move_down'
require 'printing_machine/command/use_font'

module PrintingMachine
  extend self

  def configure
    yield config
  end

  def config
    @config ||= Config.default
  end

  attr_writer :config

end
