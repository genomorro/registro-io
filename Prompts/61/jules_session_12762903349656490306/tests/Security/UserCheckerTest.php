<?php

namespace App\Tests\Security;

use App\Entity\User;
use App\Security\UserChecker;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Security\Core\Exception\CustomUserMessageAuthenticationException;

class UserCheckerTest extends TestCase
{
    public function testCheckPreAuthWithActiveUser(): void
    {
        $user = new User();
        $user->setActive(true);

        $checker = new UserChecker();
        
        // This should not throw any exception
        $checker->checkPreAuth($user);
        $this->assertTrue($user->isActive());
    }

    public function testCheckPreAuthWithInactiveUserThrowsException(): void
    {
        $user = new User();
        $user->setActive(false);

        $checker = new UserChecker();

        $this->expectException(CustomUserMessageAuthenticationException::class);
        $this->expectExceptionMessage('This user is not active, contact with an administrator.');

        $checker->checkPreAuth($user);
    }
}
