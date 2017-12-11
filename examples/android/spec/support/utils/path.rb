# -*- coding: utf-8 -*-

require 'pathname'

module PathUtil
  def screenshot_rel_path(path)
    './screenshots/' + Pathname.new(path).basename.to_s
  end

  def screenrecord_rel_path(path)
    './screenrecords/' + Pathname.new(path).basename.to_s
  end
end
