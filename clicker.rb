
def element_click(index)
  imageIndex1 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(1) > td:nth-child(1) > div")
  imageIndex2 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(1) > td:nth-child(2) > div")
  imageIndex3 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(1) > td:nth-child(3) > div")
  imageIndex4 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(1) > div")
  imageIndex5 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(2) > div")
  imageIndex6 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(2) > td:nth-child(3) > div")
  imageIndex7 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(3) > td:nth-child(1) > div")
  imageIndex8 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(3) > td:nth-child(2) > div")
  imageIndex9 = @driver.find_element(:css, "#rc-imageselect-target > table > tbody > tr:nth-child(3) > td:nth-child(3) > div")
  
  case index
  when 1
  	imageIndex1.click 
  when 2
  	imageIndex2.click
  when 3
  	imageIndex3.click
  when 4
  	imageIndex4.click
  when 5
  	imageIndex5.click 
  when 6
  	imageIndex6.click
  when 7
  	imageIndex7.click
  when 8
  	imageIndex8.click	
  when 9
  	imageIndex9.click  	
  end

end
		