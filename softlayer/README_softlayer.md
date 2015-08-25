
## Enable Softlayer CLI


### Generate and upload SSH key to Softlayer

[reference](http://knowledgelayer.softlayer.com/procedure/add-ssh-key)

	ssh-keygen -t rsa -b 4096 
	
* upload the public key to Softlayer. 

* my may need to make sure local private key has the right mode: 

	chmod -v -R 600 *.rsa


### Install Softlayer Python Client


[Reference Softlayer Python Client](https://softlayer-api-python-client.readthedocs.org/en/latest/cli/)

	sudo pip install softlayer
	
	sudo slcli setup and config created in ~/.softlayer
	

* Note: if slcli setup does not work, may need to verify if six is at level of 1.9.0

	remove previously installed six from  /Library/Python/2.7/site-packages and /System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/
	
	sudo pip install six==1.9.0 
	

[Reference CLI document](http://softlayer-python.readthedocs.org/en/latest/cli/vs.html)	


### Useful Script Sample

Scenario | Scripts | Other details
--- | --- | --- 
create VM| [createVM.sh](script-sample/createVM.sh) hostname public_key_name| revise the VM configuration as needed
create VM from image | [script-sample/createVMFromImage.sh](createVMFromImage.sh) hostname image-template-guid public_key_name| revise VM configuration as needed
Get image-template-guid | slcli image list |



