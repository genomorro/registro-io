<?php

namespace App\Form;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\NotBlank;

class SearchByFileType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('file', null, [
                'label' => 'File',
                'constraints' => [
                    new NotBlank(),
                    new Length(['min' => 6, 'max' => 9]),
                ],
            ])
        ;
    }
}
