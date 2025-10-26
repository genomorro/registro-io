<?php

namespace App\Command;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[AsCommand(
    name: 'app:create-user',
    description: 'Creates a new user.',
    hidden: false,
    aliases: ['app:add-user']
)]
class CreateUserCommand extends Command
{
    private $entityManager;
    private $passwordHasher;

    public function __construct(EntityManagerInterface $entityManager, UserPasswordHasherInterface $passwordHasher)
    {
        parent::__construct();
        $this->entityManager = $entityManager;
        $this->passwordHasher = $passwordHasher;
    }

    protected function configure()
    {
        $this
            ->setDescription('Creates a new user.')
            ->setHelp('This command allows you to create a user...')
            ->addArgument('name', InputArgument::REQUIRED, 'The name of the user.')
            ->addArgument('username', InputArgument::REQUIRED, 'The username of the user.')
            ->addArgument('password', InputArgument::REQUIRED, 'The password of the user.');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $user = new User();
        $user->setName($input->getArgument('name'));
        $user->setUsername($input->getArgument('username'));
        $user->setRoles(['ROLE_ADMIN']);
        $user->setPassword($this->passwordHasher->hashPassword(
            $user,
            $input->getArgument('password')
        ));

        $this->entityManager->persist($user);
        $this->entityManager->flush();

        $output->writeln('User successfully generated!');

        return Command::SUCCESS;
    }
}
