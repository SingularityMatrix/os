package integration

import (
	. "gopkg.in/check.v1"
)

func (s *QemuSuite) TestPreload(c *C) {
	err := s.RunQemu()
	c.Assert(err, IsNil)

	s.CheckCall(c, `
docker pull busybox
sudo docker save -o /var/lib/rancher/preload/system-docker/busybox.tar busybox
sudo system-docker pull alpine
sudo system-docker save -o /var/lib/rancher/preload/docker/alpine.tar alpine`)

	s.Reboot(c)

	s.CheckCall(c, `
sleep 5
sudo system-docker images | grep busybox
docker images | grep alpine`)
}
